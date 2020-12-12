# bash completion for gh                                   -*- shell-script -*-

__gh_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__gh_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__gh_index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__gh_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__gh_handle_go_custom_completion()
{
    __gh_debug "${FUNCNAME[0]}: cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}"

    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local out requestComp lastParam lastChar comp directive args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly gh allows to handle aliases
    args=("${words[@]:1}")
    requestComp="${words[0]} __completeNoDesc ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __gh_debug "${FUNCNAME[0]}: lastParam ${lastParam}, lastChar ${lastChar}"

    if [ -z "${cur}" ] && [ "${lastChar}" != "=" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __gh_debug "${FUNCNAME[0]}: Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __gh_debug "${FUNCNAME[0]}: calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:)
    directive=${out##*:}
    # Remove the directive
    out=${out%:*}
    if [ "${directive}" = "${out}" ]; then
        # There is not directive specified
        directive=0
    fi
    __gh_debug "${FUNCNAME[0]}: the completion directive is: ${directive}"
    __gh_debug "${FUNCNAME[0]}: the completions are: ${out[*]}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        # Error code.  No completion.
        __gh_debug "${FUNCNAME[0]}: received error from custom completion go code"
        return
    else
        if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __gh_debug "${FUNCNAME[0]}: activating no space"
                compopt -o nospace
            fi
        fi
        if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
            if [[ $(type -t compopt) = "builtin" ]]; then
                __gh_debug "${FUNCNAME[0]}: activating no file completion"
                compopt +o default
            fi
        fi
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local fullFilter filter filteringCmd
        # Do not use quotes around the $out variable or else newline
        # characters will be kept.
        for filter in ${out[*]}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __gh_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        # Use printf to strip any trailing newline
        subdir=$(printf "%s" "${out[0]}")
        if [ -n "$subdir" ]; then
            __gh_debug "Listing directories in $subdir"
            __gh_handle_subdirs_in_dir_flag "$subdir"
        else
            __gh_debug "Listing directories in ."
            _filedir -d
        fi
    else
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${out[*]}" -- "$cur")
    fi
}

__gh_handle_reply()
{
    __gh_debug "${FUNCNAME[0]}"
    local comp
    case $cur in
        -*)
            if [[ $(type -t compopt) = "builtin" ]]; then
                compopt -o nospace
            fi
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            while IFS='' read -r comp; do
                COMPREPLY+=("$comp")
            done < <(compgen -W "${allflags[*]}" -- "$cur")
            if [[ $(type -t compopt) = "builtin" ]]; then
                [[ "${COMPREPLY[0]}" == *= ]] || compopt +o nospace
            fi

            # complete after --flag=abc
            if [[ $cur == *=* ]]; then
                if [[ $(type -t compopt) = "builtin" ]]; then
                    compopt +o nospace
                fi

                local index flag
                flag="${cur%=*}"
                __gh_index_of_word "${flag}" "${flags_with_completion[@]}"
                COMPREPLY=()
                if [[ ${index} -ge 0 ]]; then
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION}" ]; then
                        # zsh completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi
            return 0;
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __gh_index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    completions=("${commands[@]}")
    if [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions+=("${must_have_one_noun[@]}")
    elif [[ -n "${has_completion_function}" ]]; then
        # if a go completion function is provided, defer to that function
        __gh_handle_go_custom_completion
    fi
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions+=("${must_have_one_flag[@]}")
    fi
    while IFS='' read -r comp; do
        COMPREPLY+=("$comp")
    done < <(compgen -W "${completions[*]}" -- "$cur")

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        while IFS='' read -r comp; do
            COMPREPLY+=("$comp")
        done < <(compgen -W "${noun_aliases[*]}" -- "$cur")
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
		if declare -F __gh_custom_func >/dev/null; then
			# try command name qualified custom func
			__gh_custom_func
		else
			# otherwise fall back to unqualified for compatibility
			declare -F __custom_func >/dev/null && __custom_func
		fi
    fi

    # available in bash-completion >= 2, not always present on macOS
    if declare -F __ltrim_colon_completions >/dev/null; then
        __ltrim_colon_completions "$cur"
    fi

    # If there is only 1 completion and it is a flag with an = it will be completed
    # but we don't want a space after the =
    if [[ "${#COMPREPLY[@]}" -eq "1" ]] && [[ $(type -t compopt) = "builtin" ]] && [[ "${COMPREPLY[0]}" == --*= ]]; then
       compopt -o nospace
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__gh_handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__gh_handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
}

__gh_handle_flag()
{
    __gh_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __gh_debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __gh_contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __gh_contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
      commands=()
    fi

    # keep flag value with flagname as flaghash
    # flaghash variable is an associative array which is only supported in bash > 3.
    if [[ -z "${BASH_VERSION}" || "${BASH_VERSINFO[0]}" -gt 3 ]]; then
        if [ -n "${flagvalue}" ] ; then
            flaghash[${flagname}]=${flagvalue}
        elif [ -n "${words[ $((c+1)) ]}" ] ; then
            flaghash[${flagname}]=${words[ $((c+1)) ]}
        else
            flaghash[${flagname}]="true" # pad "true" for bool flag
        fi
    fi

    # skip the argument to a two word flag
    if [[ ${words[c]} != *"="* ]] && __gh_contains_word "${words[c]}" "${two_word_flags[@]}"; then
			  __gh_debug "${FUNCNAME[0]}: found a flag ${words[c]}, skip the next argument"
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__gh_handle_noun()
{
    __gh_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __gh_contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __gh_contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__gh_handle_command()
{
    __gh_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_gh_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __gh_debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__gh_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __gh_handle_reply
        return
    fi
    __gh_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __gh_handle_flag
    elif __gh_contains_word "${words[c]}" "${commands[@]}"; then
        __gh_handle_command
    elif [[ $c -eq 0 ]]; then
        __gh_handle_command
    elif __gh_contains_word "${words[c]}" "${command_aliases[@]}"; then
        # aliashash variable is an associative array which is only supported in bash > 3.
        if [[ -z "${BASH_VERSION}" || "${BASH_VERSINFO[0]}" -gt 3 ]]; then
            words[c]=${aliashash[${words[c]}]}
            __gh_handle_command
        else
            __gh_handle_noun
        fi
    else
        __gh_handle_noun
    fi
    __gh_handle_word
}

_gh_alias_delete()
{
    last_command="gh_alias_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_alias_list()
{
    last_command="gh_alias_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_alias_set()
{
    last_command="gh_alias_set"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--shell")
    flags+=("-s")
    local_nonpersistent_flags+=("--shell")
    local_nonpersistent_flags+=("-s")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_alias()
{
    last_command="gh_alias"

    command_aliases=()

    commands=()
    commands+=("delete")
    commands+=("list")
    commands+=("set")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_api()
{
    last_command="gh_api"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--field=")
    two_word_flags+=("--field")
    two_word_flags+=("-F")
    local_nonpersistent_flags+=("--field")
    local_nonpersistent_flags+=("--field=")
    local_nonpersistent_flags+=("-F")
    flags+=("--header=")
    two_word_flags+=("--header")
    two_word_flags+=("-H")
    local_nonpersistent_flags+=("--header")
    local_nonpersistent_flags+=("--header=")
    local_nonpersistent_flags+=("-H")
    flags+=("--hostname=")
    two_word_flags+=("--hostname")
    local_nonpersistent_flags+=("--hostname")
    local_nonpersistent_flags+=("--hostname=")
    flags+=("--include")
    flags+=("-i")
    local_nonpersistent_flags+=("--include")
    local_nonpersistent_flags+=("-i")
    flags+=("--input=")
    two_word_flags+=("--input")
    local_nonpersistent_flags+=("--input")
    local_nonpersistent_flags+=("--input=")
    flags+=("--method=")
    two_word_flags+=("--method")
    two_word_flags+=("-X")
    local_nonpersistent_flags+=("--method")
    local_nonpersistent_flags+=("--method=")
    local_nonpersistent_flags+=("-X")
    flags+=("--paginate")
    local_nonpersistent_flags+=("--paginate")
    flags+=("--raw-field=")
    two_word_flags+=("--raw-field")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--raw-field")
    local_nonpersistent_flags+=("--raw-field=")
    local_nonpersistent_flags+=("-f")
    flags+=("--silent")
    local_nonpersistent_flags+=("--silent")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_auth_login()
{
    last_command="gh_auth_login"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--hostname=")
    two_word_flags+=("--hostname")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--hostname")
    local_nonpersistent_flags+=("--hostname=")
    local_nonpersistent_flags+=("-h")
    flags+=("--scopes=")
    two_word_flags+=("--scopes")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--scopes")
    local_nonpersistent_flags+=("--scopes=")
    local_nonpersistent_flags+=("-s")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--with-token")
    local_nonpersistent_flags+=("--with-token")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_auth_logout()
{
    last_command="gh_auth_logout"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--hostname=")
    two_word_flags+=("--hostname")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--hostname")
    local_nonpersistent_flags+=("--hostname=")
    local_nonpersistent_flags+=("-h")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_auth_refresh()
{
    last_command="gh_auth_refresh"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--hostname=")
    two_word_flags+=("--hostname")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--hostname")
    local_nonpersistent_flags+=("--hostname=")
    local_nonpersistent_flags+=("-h")
    flags+=("--scopes=")
    two_word_flags+=("--scopes")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--scopes")
    local_nonpersistent_flags+=("--scopes=")
    local_nonpersistent_flags+=("-s")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_auth_status()
{
    last_command="gh_auth_status"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--hostname=")
    two_word_flags+=("--hostname")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--hostname")
    local_nonpersistent_flags+=("--hostname=")
    local_nonpersistent_flags+=("-h")
    flags+=("--show-token")
    flags+=("-t")
    local_nonpersistent_flags+=("--show-token")
    local_nonpersistent_flags+=("-t")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_auth()
{
    last_command="gh_auth"

    command_aliases=()

    commands=()
    commands+=("login")
    commands+=("logout")
    commands+=("refresh")
    commands+=("status")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_completion()
{
    last_command="gh_completion"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--shell=")
    two_word_flags+=("--shell")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--shell")
    local_nonpersistent_flags+=("--shell=")
    local_nonpersistent_flags+=("-s")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_config_get()
{
    last_command="gh_config_get"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--host=")
    two_word_flags+=("--host")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--host")
    local_nonpersistent_flags+=("--host=")
    local_nonpersistent_flags+=("-h")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_config_set()
{
    last_command="gh_config_set"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--host=")
    two_word_flags+=("--host")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--host")
    local_nonpersistent_flags+=("--host=")
    local_nonpersistent_flags+=("-h")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_config()
{
    last_command="gh_config"

    command_aliases=()

    commands=()
    commands+=("get")
    commands+=("set")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_gist_create()
{
    last_command="gh_gist_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--desc=")
    two_word_flags+=("--desc")
    two_word_flags+=("-d")
    local_nonpersistent_flags+=("--desc")
    local_nonpersistent_flags+=("--desc=")
    local_nonpersistent_flags+=("-d")
    flags+=("--filename=")
    two_word_flags+=("--filename")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--filename")
    local_nonpersistent_flags+=("--filename=")
    local_nonpersistent_flags+=("-f")
    flags+=("--public")
    flags+=("-p")
    local_nonpersistent_flags+=("--public")
    local_nonpersistent_flags+=("-p")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_gist_delete()
{
    last_command="gh_gist_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_gist_edit()
{
    last_command="gh_gist_edit"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    two_word_flags+=("--filename")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--filename")
    local_nonpersistent_flags+=("--filename=")
    local_nonpersistent_flags+=("-f")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_gist_list()
{
    last_command="gh_gist_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--limit=")
    two_word_flags+=("--limit")
    two_word_flags+=("-L")
    local_nonpersistent_flags+=("--limit")
    local_nonpersistent_flags+=("--limit=")
    local_nonpersistent_flags+=("-L")
    flags+=("--public")
    local_nonpersistent_flags+=("--public")
    flags+=("--secret")
    local_nonpersistent_flags+=("--secret")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_gist_view()
{
    last_command="gh_gist_view"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--filename=")
    two_word_flags+=("--filename")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--filename")
    local_nonpersistent_flags+=("--filename=")
    local_nonpersistent_flags+=("-f")
    flags+=("--raw")
    flags+=("-r")
    local_nonpersistent_flags+=("--raw")
    local_nonpersistent_flags+=("-r")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_gist()
{
    last_command="gh_gist"

    command_aliases=()

    commands=()
    commands+=("create")
    commands+=("delete")
    commands+=("edit")
    commands+=("list")
    commands+=("view")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_help()
{
    last_command="gh_help"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    has_completion_function=1
    noun_aliases=()
}

_gh_issue_close()
{
    last_command="gh_issue_close"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_issue_create()
{
    last_command="gh_issue_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--assignee=")
    two_word_flags+=("--assignee")
    two_word_flags+=("-a")
    local_nonpersistent_flags+=("--assignee")
    local_nonpersistent_flags+=("--assignee=")
    local_nonpersistent_flags+=("-a")
    flags+=("--body=")
    two_word_flags+=("--body")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--body")
    local_nonpersistent_flags+=("--body=")
    local_nonpersistent_flags+=("-b")
    flags+=("--label=")
    two_word_flags+=("--label")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--label")
    local_nonpersistent_flags+=("--label=")
    local_nonpersistent_flags+=("-l")
    flags+=("--milestone=")
    two_word_flags+=("--milestone")
    two_word_flags+=("-m")
    local_nonpersistent_flags+=("--milestone")
    local_nonpersistent_flags+=("--milestone=")
    local_nonpersistent_flags+=("-m")
    flags+=("--project=")
    two_word_flags+=("--project")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--project")
    local_nonpersistent_flags+=("--project=")
    local_nonpersistent_flags+=("-p")
    flags+=("--recover=")
    two_word_flags+=("--recover")
    local_nonpersistent_flags+=("--recover")
    local_nonpersistent_flags+=("--recover=")
    flags+=("--title=")
    two_word_flags+=("--title")
    two_word_flags+=("-t")
    local_nonpersistent_flags+=("--title")
    local_nonpersistent_flags+=("--title=")
    local_nonpersistent_flags+=("-t")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_issue_list()
{
    last_command="gh_issue_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--assignee=")
    two_word_flags+=("--assignee")
    two_word_flags+=("-a")
    local_nonpersistent_flags+=("--assignee")
    local_nonpersistent_flags+=("--assignee=")
    local_nonpersistent_flags+=("-a")
    flags+=("--author=")
    two_word_flags+=("--author")
    two_word_flags+=("-A")
    local_nonpersistent_flags+=("--author")
    local_nonpersistent_flags+=("--author=")
    local_nonpersistent_flags+=("-A")
    flags+=("--label=")
    two_word_flags+=("--label")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--label")
    local_nonpersistent_flags+=("--label=")
    local_nonpersistent_flags+=("-l")
    flags+=("--limit=")
    two_word_flags+=("--limit")
    two_word_flags+=("-L")
    local_nonpersistent_flags+=("--limit")
    local_nonpersistent_flags+=("--limit=")
    local_nonpersistent_flags+=("-L")
    flags+=("--mention=")
    two_word_flags+=("--mention")
    local_nonpersistent_flags+=("--mention")
    local_nonpersistent_flags+=("--mention=")
    flags+=("--milestone=")
    two_word_flags+=("--milestone")
    two_word_flags+=("-m")
    local_nonpersistent_flags+=("--milestone")
    local_nonpersistent_flags+=("--milestone=")
    local_nonpersistent_flags+=("-m")
    flags+=("--state=")
    two_word_flags+=("--state")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--state")
    local_nonpersistent_flags+=("--state=")
    local_nonpersistent_flags+=("-s")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_issue_reopen()
{
    last_command="gh_issue_reopen"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_issue_status()
{
    last_command="gh_issue_status"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_issue_view()
{
    last_command="gh_issue_view"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_issue()
{
    last_command="gh_issue"

    command_aliases=()

    commands=()
    commands+=("close")
    commands+=("create")
    commands+=("list")
    commands+=("reopen")
    commands+=("status")
    commands+=("view")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_checkout()
{
    last_command="gh_pr_checkout"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--recurse-submodules")
    local_nonpersistent_flags+=("--recurse-submodules")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_checks()
{
    last_command="gh_pr_checks"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_close()
{
    last_command="gh_pr_close"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--delete-branch")
    flags+=("-d")
    local_nonpersistent_flags+=("--delete-branch")
    local_nonpersistent_flags+=("-d")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_create()
{
    last_command="gh_pr_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--assignee=")
    two_word_flags+=("--assignee")
    two_word_flags+=("-a")
    local_nonpersistent_flags+=("--assignee")
    local_nonpersistent_flags+=("--assignee=")
    local_nonpersistent_flags+=("-a")
    flags+=("--base=")
    two_word_flags+=("--base")
    two_word_flags+=("-B")
    local_nonpersistent_flags+=("--base")
    local_nonpersistent_flags+=("--base=")
    local_nonpersistent_flags+=("-B")
    flags+=("--body=")
    two_word_flags+=("--body")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--body")
    local_nonpersistent_flags+=("--body=")
    local_nonpersistent_flags+=("-b")
    flags+=("--draft")
    flags+=("-d")
    local_nonpersistent_flags+=("--draft")
    local_nonpersistent_flags+=("-d")
    flags+=("--fill")
    flags+=("-f")
    local_nonpersistent_flags+=("--fill")
    local_nonpersistent_flags+=("-f")
    flags+=("--head=")
    two_word_flags+=("--head")
    two_word_flags+=("-H")
    local_nonpersistent_flags+=("--head")
    local_nonpersistent_flags+=("--head=")
    local_nonpersistent_flags+=("-H")
    flags+=("--label=")
    two_word_flags+=("--label")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--label")
    local_nonpersistent_flags+=("--label=")
    local_nonpersistent_flags+=("-l")
    flags+=("--milestone=")
    two_word_flags+=("--milestone")
    two_word_flags+=("-m")
    local_nonpersistent_flags+=("--milestone")
    local_nonpersistent_flags+=("--milestone=")
    local_nonpersistent_flags+=("-m")
    flags+=("--project=")
    two_word_flags+=("--project")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--project")
    local_nonpersistent_flags+=("--project=")
    local_nonpersistent_flags+=("-p")
    flags+=("--recover=")
    two_word_flags+=("--recover")
    local_nonpersistent_flags+=("--recover")
    local_nonpersistent_flags+=("--recover=")
    flags+=("--reviewer=")
    two_word_flags+=("--reviewer")
    two_word_flags+=("-r")
    local_nonpersistent_flags+=("--reviewer")
    local_nonpersistent_flags+=("--reviewer=")
    local_nonpersistent_flags+=("-r")
    flags+=("--title=")
    two_word_flags+=("--title")
    two_word_flags+=("-t")
    local_nonpersistent_flags+=("--title")
    local_nonpersistent_flags+=("--title=")
    local_nonpersistent_flags+=("-t")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_diff()
{
    last_command="gh_pr_diff"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    local_nonpersistent_flags+=("--color")
    local_nonpersistent_flags+=("--color=")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_list()
{
    last_command="gh_pr_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--assignee=")
    two_word_flags+=("--assignee")
    two_word_flags+=("-a")
    local_nonpersistent_flags+=("--assignee")
    local_nonpersistent_flags+=("--assignee=")
    local_nonpersistent_flags+=("-a")
    flags+=("--base=")
    two_word_flags+=("--base")
    two_word_flags+=("-B")
    local_nonpersistent_flags+=("--base")
    local_nonpersistent_flags+=("--base=")
    local_nonpersistent_flags+=("-B")
    flags+=("--label=")
    two_word_flags+=("--label")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--label")
    local_nonpersistent_flags+=("--label=")
    local_nonpersistent_flags+=("-l")
    flags+=("--limit=")
    two_word_flags+=("--limit")
    two_word_flags+=("-L")
    local_nonpersistent_flags+=("--limit")
    local_nonpersistent_flags+=("--limit=")
    local_nonpersistent_flags+=("-L")
    flags+=("--state=")
    two_word_flags+=("--state")
    two_word_flags+=("-s")
    local_nonpersistent_flags+=("--state")
    local_nonpersistent_flags+=("--state=")
    local_nonpersistent_flags+=("-s")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_merge()
{
    last_command="gh_pr_merge"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--delete-branch")
    flags+=("-d")
    local_nonpersistent_flags+=("--delete-branch")
    local_nonpersistent_flags+=("-d")
    flags+=("--merge")
    flags+=("-m")
    local_nonpersistent_flags+=("--merge")
    local_nonpersistent_flags+=("-m")
    flags+=("--rebase")
    flags+=("-r")
    local_nonpersistent_flags+=("--rebase")
    local_nonpersistent_flags+=("-r")
    flags+=("--squash")
    flags+=("-s")
    local_nonpersistent_flags+=("--squash")
    local_nonpersistent_flags+=("-s")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_ready()
{
    last_command="gh_pr_ready"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_reopen()
{
    last_command="gh_pr_reopen"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_review()
{
    last_command="gh_pr_review"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--approve")
    flags+=("-a")
    local_nonpersistent_flags+=("--approve")
    local_nonpersistent_flags+=("-a")
    flags+=("--body=")
    two_word_flags+=("--body")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--body")
    local_nonpersistent_flags+=("--body=")
    local_nonpersistent_flags+=("-b")
    flags+=("--comment")
    flags+=("-c")
    local_nonpersistent_flags+=("--comment")
    local_nonpersistent_flags+=("-c")
    flags+=("--request-changes")
    flags+=("-r")
    local_nonpersistent_flags+=("--request-changes")
    local_nonpersistent_flags+=("-r")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_status()
{
    last_command="gh_pr_status"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr_view()
{
    last_command="gh_pr_view"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_pr()
{
    last_command="gh_pr"

    command_aliases=()

    commands=()
    commands+=("checkout")
    commands+=("checks")
    commands+=("close")
    commands+=("create")
    commands+=("diff")
    commands+=("list")
    commands+=("merge")
    commands+=("ready")
    commands+=("reopen")
    commands+=("review")
    commands+=("status")
    commands+=("view")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release_create()
{
    last_command="gh_release_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--draft")
    flags+=("-d")
    local_nonpersistent_flags+=("--draft")
    local_nonpersistent_flags+=("-d")
    flags+=("--notes=")
    two_word_flags+=("--notes")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--notes")
    local_nonpersistent_flags+=("--notes=")
    local_nonpersistent_flags+=("-n")
    flags+=("--notes-file=")
    two_word_flags+=("--notes-file")
    two_word_flags+=("-F")
    local_nonpersistent_flags+=("--notes-file")
    local_nonpersistent_flags+=("--notes-file=")
    local_nonpersistent_flags+=("-F")
    flags+=("--prerelease")
    flags+=("-p")
    local_nonpersistent_flags+=("--prerelease")
    local_nonpersistent_flags+=("-p")
    flags+=("--target=")
    two_word_flags+=("--target")
    local_nonpersistent_flags+=("--target")
    local_nonpersistent_flags+=("--target=")
    flags+=("--title=")
    two_word_flags+=("--title")
    two_word_flags+=("-t")
    local_nonpersistent_flags+=("--title")
    local_nonpersistent_flags+=("--title=")
    local_nonpersistent_flags+=("-t")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release_delete()
{
    last_command="gh_release_delete"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--yes")
    flags+=("-y")
    local_nonpersistent_flags+=("--yes")
    local_nonpersistent_flags+=("-y")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release_download()
{
    last_command="gh_release_download"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    two_word_flags+=("--dir")
    two_word_flags+=("-D")
    local_nonpersistent_flags+=("--dir")
    local_nonpersistent_flags+=("--dir=")
    local_nonpersistent_flags+=("-D")
    flags+=("--pattern=")
    two_word_flags+=("--pattern")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--pattern")
    local_nonpersistent_flags+=("--pattern=")
    local_nonpersistent_flags+=("-p")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release_list()
{
    last_command="gh_release_list"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--limit=")
    two_word_flags+=("--limit")
    two_word_flags+=("-L")
    local_nonpersistent_flags+=("--limit")
    local_nonpersistent_flags+=("--limit=")
    local_nonpersistent_flags+=("-L")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release_upload()
{
    last_command="gh_release_upload"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--clobber")
    local_nonpersistent_flags+=("--clobber")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release_view()
{
    last_command="gh_release_view"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")
    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_release()
{
    last_command="gh_release"

    command_aliases=()

    commands=()
    commands+=("create")
    commands+=("delete")
    commands+=("download")
    commands+=("list")
    commands+=("upload")
    commands+=("view")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--repo=")
    two_word_flags+=("--repo")
    two_word_flags+=("-R")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_repo_clone()
{
    last_command="gh_repo_clone"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_repo_create()
{
    last_command="gh_repo_create"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--confirm")
    flags+=("-y")
    local_nonpersistent_flags+=("--confirm")
    local_nonpersistent_flags+=("-y")
    flags+=("--description=")
    two_word_flags+=("--description")
    two_word_flags+=("-d")
    local_nonpersistent_flags+=("--description")
    local_nonpersistent_flags+=("--description=")
    local_nonpersistent_flags+=("-d")
    flags+=("--enable-issues")
    local_nonpersistent_flags+=("--enable-issues")
    flags+=("--enable-wiki")
    local_nonpersistent_flags+=("--enable-wiki")
    flags+=("--homepage=")
    two_word_flags+=("--homepage")
    two_word_flags+=("-h")
    local_nonpersistent_flags+=("--homepage")
    local_nonpersistent_flags+=("--homepage=")
    local_nonpersistent_flags+=("-h")
    flags+=("--internal")
    local_nonpersistent_flags+=("--internal")
    flags+=("--private")
    local_nonpersistent_flags+=("--private")
    flags+=("--public")
    local_nonpersistent_flags+=("--public")
    flags+=("--team=")
    two_word_flags+=("--team")
    two_word_flags+=("-t")
    local_nonpersistent_flags+=("--team")
    local_nonpersistent_flags+=("--team=")
    local_nonpersistent_flags+=("-t")
    flags+=("--template=")
    two_word_flags+=("--template")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--template")
    local_nonpersistent_flags+=("--template=")
    local_nonpersistent_flags+=("-p")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_repo_fork()
{
    last_command="gh_repo_fork"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--clone")
    local_nonpersistent_flags+=("--clone")
    flags+=("--remote")
    local_nonpersistent_flags+=("--remote")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_repo_view()
{
    last_command="gh_repo_view"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--branch=")
    two_word_flags+=("--branch")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--branch")
    local_nonpersistent_flags+=("--branch=")
    local_nonpersistent_flags+=("-b")
    flags+=("--web")
    flags+=("-w")
    local_nonpersistent_flags+=("--web")
    local_nonpersistent_flags+=("-w")
    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_repo()
{
    last_command="gh_repo"

    command_aliases=()

    commands=()
    commands+=("clone")
    commands+=("create")
    commands+=("fork")
    commands+=("view")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_gh_root_command()
{
    last_command="gh"

    command_aliases=()

    commands=()
    commands+=("alias")
    commands+=("api")
    commands+=("auth")
    commands+=("completion")
    commands+=("config")
    commands+=("gist")
    commands+=("help")
    commands+=("issue")
    commands+=("pr")
    commands+=("release")
    commands+=("repo")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("--version")
    local_nonpersistent_flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_gh()
{
    local cur prev words cword
    declare -A flaghash 2>/dev/null || :
    declare -A aliashash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __gh_init_completion -n "=" || return
    fi

    local c=0
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("gh")
    local must_have_one_flag=()
    local must_have_one_noun=()
    local has_completion_function
    local last_command
    local nouns=()

    __gh_handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_gh gh
else
    complete -o default -o nospace -F __start_gh gh
fi

# ex: ts=4 sw=4 et filetype=sh
