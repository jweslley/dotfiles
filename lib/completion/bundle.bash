# Bash completion support for Bundler.
#
#  Copyright (C) 2012 Jonhnny Weslley <http://www.jonhnnyweslley.net>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#  The latest version of this software can be obtained here:
#
#  http://github.com/jweslley/dotfiles
#
#  VERSION: 0.1.0


global_options="--no-color --verbose"

# helper functions -------------------------------------------------------------

__bundlecomp(){
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $( compgen -W "$1" -- "$cur" ) )
}

__bundlecomp_opts(){
  __bundlecomp "$1 $global_options"
}

__bundlecmd(){
  any_command=$(echo $2 | sed -e 's/[[:space:]]/|/g')
  for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )); do
    if [[ ${COMP_WORDS[i]} == @($any_command) ]]; then
      eval $1="${COMP_WORDS[i]}"
    fi
  done
}

__bundle_gems(){
  __railscomp "$(egrep "^[[:space:]]{4}" Gemfile.lock | awk '{print $1}' | sort -u)"
}

__bundlecomp_with_gems(){
  local cur
  _get_comp_words_by_ref cur

  case "$cur" in
    -*) __bundlecomp_opts "$1" ;;
    *) __bundle_gems ;;
  esac
}

# end of helper functions ------------------------------------------------------


# bundle commands --------------------------------------------------------------

_bundle_cache(){
  __bundlecomp_opts "--no-prune --all"
}

_bundle_check(){
  __bundlecomp_opts "--gemfile --path"
}

_bundle_clean(){
  __bundlecomp_opts "--force"
}

_bundle_config(){
  __bundlecomp_opts ""
}

_bundle_console(){
  __bundlecomp_opts ""
}

_bundle_exec(){
  __bundlecomp_opts ""
}

_bundle_gem(){
  __bundlecomp_opts "--bin"
}

_bundle_init(){
  __bundlecomp_opts "--gemspec"
}

_bundle_install(){
  __bundlecomp_opts "--binstubs --clean --deployment --frozen --full-index --gemfile --local --no-cache --no-prune --path --quiet --shebang --standalone --system --without"
}

_bundle_open(){
  __bundle_gems
}

_bundle_outdated(){
  __bundlecomp_with_gems "--local --pre --source"
}

_bundle_package(){
  __bundlecomp_opts "--no-prune --all"
}

_bundle_platform(){
  __bundlecomp_opts "--ruby"
}

_bundle_show(){
  __bundlecomp_with_gems "--paths"
}

_bundle_update(){
  __bundlecomp_with_gems "--local --source"
}

_bundle_viz(){
  __bundlecomp_opts "--file --format --requirements --version"
}

# end of bundle commands -------------------------------------------------------


_bundle(){
  local cur command commands

  commands="cache check clean config console exec gem init install open outdated package platform show update version viz"

  _get_comp_words_by_ref cur
  __bundlecmd command "$commands"

  if [ -z "$command" ]; then
    case "$cur" in
      -*) __bundlecomp "--help" ;;
      *) __bundlecomp "$commands" ;;
    esac
    return
  fi

	local completion_func="_bundle_$command"
	declare -f $completion_func > /dev/null && $completion_func
}

complete -o default -F _bundle bundle
