# Navigation
alias cdd='cd "$HOME/dotfiles"'
alias cdw='cd "$HOME/works"'
alias cdp='cd ..'
alias cdpp='cd ../..'
alias cds='cd -'

# Listing
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ks='ls'
alias sl='ls'

# Editors
alias vi='vim'
alias v='vim'

# Git
alias g='git'
alias gs='git status --short'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --decorate --graph --all'

# Language/runtime shortcuts
alias py='python3'
alias pip='python3 -m pip'
alias gpp='g++'
alias g11='g++ -std=c++11'
alias g14='g++ -std=c++14'
alias g17='g++ -std=c++17'

# Safer removal when trash-cli is installed.
if command -v trash-put >/dev/null 2>&1; then
  alias rm='trash-put'
fi

# Clipboard helpers.
if command -v pbcopy >/dev/null 2>&1; then
  alias clipboard='pbcopy'
  alias paste='pbpaste'
elif command -v xsel >/dev/null 2>&1; then
  alias clipboard='xsel --clipboard --input'
  alias paste='xsel --clipboard --output'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v delta >/dev/null 2>&1; then
  alias diff='delta'
fi

if command -v fzf >/dev/null 2>&1; then
  alias fzfp='fzf --preview "bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || sed -n '\''1,200p'\'' {}"'
fi

# Jump to the worktree of a pull request. Accepts a PR URL, a bare PR
# number (must be run from inside the target repository), or
# "owner/repo#number". Fork (cross-repository) pull requests are not
# supported. Clones missing repositories with ghq and creates missing
# worktrees with gwq, then cd's the current shell into the result.
if command -v gh >/dev/null 2>&1 && command -v ghq >/dev/null 2>&1 && command -v gwq >/dev/null 2>&1; then
  # Resolve a repository's origin remote to "host/owner/repo".
  _prcd_remote_slug() {
    local dir="$1" remote host rest owner repo
    remote=$(git -C "$dir" remote get-url origin 2>/dev/null) || return 1
    remote="${remote%.git}"
    if [[ "$remote" =~ ^git@([^:]+):(.+)$ ]]; then
      host="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"
    elif [[ "$remote" =~ ^ssh://(git@)?([^/]+)/(.+)$ ]]; then
      host="${BASH_REMATCH[2]}"
      rest="${BASH_REMATCH[3]}"
    elif [[ "$remote" =~ ^https?://([^/]+)/(.+)$ ]]; then
      host="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"
    else
      return 1
    fi
    owner="${rest%%/*}"
    repo="${rest##*/}"
    printf '%s/%s/%s\n' "$host" "$owner" "$repo"
  }

  # Find (or clone) the local checkout for host/owner/repo.
  _prcd_repo_dir() {
    local host="$1" owner="$2" repo="$3" dir slug candidate
    dir=$(ghq list --full-path --exact "$owner/$repo" 2>/dev/null | head -n 1)
    if [ -n "$dir" ]; then
      printf '%s\n' "$dir"
      return 0
    fi
    while IFS= read -r candidate; do
      slug=$(_prcd_remote_slug "$candidate") || continue
      if [ "$slug" = "$host/$owner/$repo" ]; then
        printf '%s\n' "$candidate"
        return 0
      fi
    done < <(ghq list --full-path 2>/dev/null)
    ghq get "$host/$owner/$repo" >&2 || return 1
    dir=$(ghq list --full-path --exact "$owner/$repo" 2>/dev/null | head -n 1)
    [ -n "$dir" ] || return 1
    printf '%s\n' "$dir"
  }

  # Find the worktree directory already checked out to a given branch.
  _prcd_worktree_dir() {
    local repo_dir="$1" branch="$2"
    git -C "$repo_dir" worktree list --porcelain 2>/dev/null | awk -v ref="branch refs/heads/$branch" '
      /^worktree / { path = substr($0, 10) }
      $0 == ref    { print path; exit }
    '
  }

  prcd() {
    local pr="$1" repo_arg tsv url branch cross slug host owner repo repo_dir worktree_dir

    if [ -z "$pr" ]; then
      echo "Usage: prcd <pr-url|pr-number|owner/repo#number>" >&2
      return 1
    fi

    repo_arg=""
    case "$pr" in
      https://*/pull/*|http://*/pull/*)
        ;;
      */*#[0-9]*)
        repo_arg="${pr%%#*}"
        pr="${pr##*#}"
        ;;
      [0-9]*)
        ;;
      *)
        echo "Usage: prcd <pr-url|pr-number|owner/repo#number>" >&2
        return 1
        ;;
    esac

    if [ -n "$repo_arg" ]; then
      tsv=$(gh pr view "$pr" --repo "$repo_arg" --json url,headRefName,isCrossRepository --jq '[.url, .headRefName, .isCrossRepository] | @tsv') || return 1
    else
      tsv=$(gh pr view "$pr" --json url,headRefName,isCrossRepository --jq '[.url, .headRefName, .isCrossRepository] | @tsv') || return 1
    fi
    IFS=$'\t' read -r url branch cross <<<"$tsv"

    if [ "$cross" = "true" ]; then
      echo "prcd: pull requests from forks are not supported" >&2
      return 1
    fi

    slug=$(printf '%s\n' "$url" | sed -E 's#^https?://([^/]+)/([^/]+)/([^/]+)/pull/[0-9]+.*#\1 \2 \3#')
    read -r host owner repo <<<"$slug"
    if [ -z "$host" ] || [ -z "$owner" ] || [ -z "$repo" ]; then
      echo "prcd: could not parse pull request URL: $url" >&2
      return 1
    fi

    repo_dir=$(_prcd_repo_dir "$host" "$owner" "$repo") || {
      echo "prcd: could not locate or clone $owner/$repo" >&2
      return 1
    }

    if ! git -C "$repo_dir" show-ref --verify --quiet "refs/heads/$branch"; then
      git -C "$repo_dir" fetch origin "refs/heads/$branch:refs/heads/$branch" || {
        echo "prcd: could not fetch branch $branch (it may have been deleted)" >&2
        return 1
      }
    fi

    worktree_dir=$(_prcd_worktree_dir "$repo_dir" "$branch")
    if [ -z "$worktree_dir" ]; then
      (cd "$repo_dir" && gwq add "$branch") >&2 || return 1
      worktree_dir=$(_prcd_worktree_dir "$repo_dir" "$branch")
    fi

    if [ -z "$worktree_dir" ]; then
      echo "prcd: worktree for branch $branch was not created" >&2
      return 1
    fi

    echo "$worktree_dir"
    cd "$worktree_dir" || return 1
  }
fi
