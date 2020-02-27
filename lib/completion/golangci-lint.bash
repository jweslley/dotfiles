# bash completion for golangci-lint                        -*- shell-script -*-

__golangci-lint_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__golangci-lint_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__golangci-lint_index_of_word()
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

__golangci-lint_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__golangci-lint_handle_reply()
{
    __golangci-lint_debug "${FUNCNAME[0]}"
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
            COMPREPLY=( $(compgen -W "${allflags[*]}" -- "$cur") )
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
                __golangci-lint_index_of_word "${flag}" "${flags_with_completion[@]}"
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
    __golangci-lint_index_of_word "${prev}" "${flags_with_completion[@]}"
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
        completions=("${must_have_one_noun[@]}")
    fi
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions+=("${must_have_one_flag[@]}")
    fi
    COMPREPLY=( $(compgen -W "${completions[*]}" -- "$cur") )

    if [[ ${#COMPREPLY[@]} -eq 0 && ${#noun_aliases[@]} -gt 0 && ${#must_have_one_noun[@]} -ne 0 ]]; then
        COMPREPLY=( $(compgen -W "${noun_aliases[*]}" -- "$cur") )
    fi

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
		if declare -F __golangci-lint_custom_func >/dev/null; then
			# try command name qualified custom func
			__golangci-lint_custom_func
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
__golangci-lint_handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__golangci-lint_handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1
}

__golangci-lint_handle_flag()
{
    __golangci-lint_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __golangci-lint_debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __golangci-lint_contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __golangci-lint_contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
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
    if [[ ${words[c]} != *"="* ]] && __golangci-lint_contains_word "${words[c]}" "${two_word_flags[@]}"; then
			  __golangci-lint_debug "${FUNCNAME[0]}: found a flag ${words[c]}, skip the next argument"
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__golangci-lint_handle_noun()
{
    __golangci-lint_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __golangci-lint_contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __golangci-lint_contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__golangci-lint_handle_command()
{
    __golangci-lint_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_golangci-lint_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __golangci-lint_debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__golangci-lint_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __golangci-lint_handle_reply
        return
    fi
    __golangci-lint_debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __golangci-lint_handle_flag
    elif __golangci-lint_contains_word "${words[c]}" "${commands[@]}"; then
        __golangci-lint_handle_command
    elif [[ $c -eq 0 ]]; then
        __golangci-lint_handle_command
    elif __golangci-lint_contains_word "${words[c]}" "${command_aliases[@]}"; then
        # aliashash variable is an associative array which is only supported in bash > 3.
        if [[ -z "${BASH_VERSION}" || "${BASH_VERSINFO[0]}" -gt 3 ]]; then
            words[c]=${aliashash[${words[c]}]}
            __golangci-lint_handle_command
        else
            __golangci-lint_handle_noun
        fi
    else
        __golangci-lint_handle_noun
    fi
    __golangci-lint_handle_word
}

_golangci-lint_cache_clean()
{
    last_command="golangci-lint_cache_clean"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_cache_status()
{
    last_command="golangci-lint_cache_status"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_cache()
{
    last_command="golangci-lint_cache"

    command_aliases=()

    commands=()
    commands+=("clean")
    commands+=("status")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_completion_bash()
{
    last_command="golangci-lint_completion_bash"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")
    local_nonpersistent_flags+=("--help")
    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_completion_zsh()
{
    last_command="golangci-lint_completion_zsh"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_completion()
{
    last_command="golangci-lint_completion"

    command_aliases=()

    commands=()
    commands+=("bash")
    commands+=("zsh")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_config_path()
{
    last_command="golangci-lint_config_path"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--out-format=")
    two_word_flags+=("--out-format")
    local_nonpersistent_flags+=("--out-format=")
    flags+=("--print-issued-lines")
    local_nonpersistent_flags+=("--print-issued-lines")
    flags+=("--print-linter-name")
    local_nonpersistent_flags+=("--print-linter-name")
    flags+=("--uniq-by-line")
    local_nonpersistent_flags+=("--uniq-by-line")
    flags+=("--modules-download-mode=")
    two_word_flags+=("--modules-download-mode")
    local_nonpersistent_flags+=("--modules-download-mode=")
    flags+=("--issues-exit-code=")
    two_word_flags+=("--issues-exit-code")
    local_nonpersistent_flags+=("--issues-exit-code=")
    flags+=("--build-tags=")
    two_word_flags+=("--build-tags")
    local_nonpersistent_flags+=("--build-tags=")
    flags+=("--timeout=")
    two_word_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout=")
    flags+=("--tests")
    local_nonpersistent_flags+=("--tests")
    flags+=("--print-resources-usage")
    local_nonpersistent_flags+=("--print-resources-usage")
    flags+=("--config=")
    two_word_flags+=("--config")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--config=")
    flags+=("--no-config")
    local_nonpersistent_flags+=("--no-config")
    flags+=("--skip-dirs=")
    two_word_flags+=("--skip-dirs")
    local_nonpersistent_flags+=("--skip-dirs=")
    flags+=("--skip-dirs-use-default")
    local_nonpersistent_flags+=("--skip-dirs-use-default")
    flags+=("--skip-files=")
    two_word_flags+=("--skip-files")
    local_nonpersistent_flags+=("--skip-files=")
    flags+=("--enable=")
    two_word_flags+=("--enable")
    two_word_flags+=("-E")
    local_nonpersistent_flags+=("--enable=")
    flags+=("--disable=")
    two_word_flags+=("--disable")
    two_word_flags+=("-D")
    local_nonpersistent_flags+=("--disable=")
    flags+=("--disable-all")
    local_nonpersistent_flags+=("--disable-all")
    flags+=("--presets=")
    two_word_flags+=("--presets")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--presets=")
    flags+=("--fast")
    local_nonpersistent_flags+=("--fast")
    flags+=("--exclude=")
    two_word_flags+=("--exclude")
    two_word_flags+=("-e")
    local_nonpersistent_flags+=("--exclude=")
    flags+=("--exclude-use-default")
    local_nonpersistent_flags+=("--exclude-use-default")
    flags+=("--max-issues-per-linter=")
    two_word_flags+=("--max-issues-per-linter")
    local_nonpersistent_flags+=("--max-issues-per-linter=")
    flags+=("--max-same-issues=")
    two_word_flags+=("--max-same-issues")
    local_nonpersistent_flags+=("--max-same-issues=")
    flags+=("--new")
    flags+=("-n")
    local_nonpersistent_flags+=("--new")
    flags+=("--new-from-rev=")
    two_word_flags+=("--new-from-rev")
    local_nonpersistent_flags+=("--new-from-rev=")
    flags+=("--new-from-patch=")
    two_word_flags+=("--new-from-patch")
    local_nonpersistent_flags+=("--new-from-patch=")
    flags+=("--fix")
    local_nonpersistent_flags+=("--fix")
    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_config()
{
    last_command="golangci-lint_config"

    command_aliases=()

    commands=()
    commands+=("path")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_linters()
{
    last_command="golangci-lint_linters"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--out-format=")
    two_word_flags+=("--out-format")
    local_nonpersistent_flags+=("--out-format=")
    flags+=("--print-issued-lines")
    local_nonpersistent_flags+=("--print-issued-lines")
    flags+=("--print-linter-name")
    local_nonpersistent_flags+=("--print-linter-name")
    flags+=("--uniq-by-line")
    local_nonpersistent_flags+=("--uniq-by-line")
    flags+=("--modules-download-mode=")
    two_word_flags+=("--modules-download-mode")
    local_nonpersistent_flags+=("--modules-download-mode=")
    flags+=("--issues-exit-code=")
    two_word_flags+=("--issues-exit-code")
    local_nonpersistent_flags+=("--issues-exit-code=")
    flags+=("--build-tags=")
    two_word_flags+=("--build-tags")
    local_nonpersistent_flags+=("--build-tags=")
    flags+=("--timeout=")
    two_word_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout=")
    flags+=("--tests")
    local_nonpersistent_flags+=("--tests")
    flags+=("--print-resources-usage")
    local_nonpersistent_flags+=("--print-resources-usage")
    flags+=("--config=")
    two_word_flags+=("--config")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--config=")
    flags+=("--no-config")
    local_nonpersistent_flags+=("--no-config")
    flags+=("--skip-dirs=")
    two_word_flags+=("--skip-dirs")
    local_nonpersistent_flags+=("--skip-dirs=")
    flags+=("--skip-dirs-use-default")
    local_nonpersistent_flags+=("--skip-dirs-use-default")
    flags+=("--skip-files=")
    two_word_flags+=("--skip-files")
    local_nonpersistent_flags+=("--skip-files=")
    flags+=("--enable=")
    two_word_flags+=("--enable")
    two_word_flags+=("-E")
    local_nonpersistent_flags+=("--enable=")
    flags+=("--disable=")
    two_word_flags+=("--disable")
    two_word_flags+=("-D")
    local_nonpersistent_flags+=("--disable=")
    flags+=("--disable-all")
    local_nonpersistent_flags+=("--disable-all")
    flags+=("--presets=")
    two_word_flags+=("--presets")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--presets=")
    flags+=("--fast")
    local_nonpersistent_flags+=("--fast")
    flags+=("--exclude=")
    two_word_flags+=("--exclude")
    two_word_flags+=("-e")
    local_nonpersistent_flags+=("--exclude=")
    flags+=("--exclude-use-default")
    local_nonpersistent_flags+=("--exclude-use-default")
    flags+=("--max-issues-per-linter=")
    two_word_flags+=("--max-issues-per-linter")
    local_nonpersistent_flags+=("--max-issues-per-linter=")
    flags+=("--max-same-issues=")
    two_word_flags+=("--max-same-issues")
    local_nonpersistent_flags+=("--max-same-issues=")
    flags+=("--new")
    flags+=("-n")
    local_nonpersistent_flags+=("--new")
    flags+=("--new-from-rev=")
    two_word_flags+=("--new-from-rev")
    local_nonpersistent_flags+=("--new-from-rev=")
    flags+=("--new-from-patch=")
    two_word_flags+=("--new-from-patch")
    local_nonpersistent_flags+=("--new-from-patch=")
    flags+=("--fix")
    local_nonpersistent_flags+=("--fix")
    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_run()
{
    last_command="golangci-lint_run"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--out-format=")
    two_word_flags+=("--out-format")
    local_nonpersistent_flags+=("--out-format=")
    flags+=("--print-issued-lines")
    local_nonpersistent_flags+=("--print-issued-lines")
    flags+=("--print-linter-name")
    local_nonpersistent_flags+=("--print-linter-name")
    flags+=("--uniq-by-line")
    local_nonpersistent_flags+=("--uniq-by-line")
    flags+=("--modules-download-mode=")
    two_word_flags+=("--modules-download-mode")
    local_nonpersistent_flags+=("--modules-download-mode=")
    flags+=("--issues-exit-code=")
    two_word_flags+=("--issues-exit-code")
    local_nonpersistent_flags+=("--issues-exit-code=")
    flags+=("--build-tags=")
    two_word_flags+=("--build-tags")
    local_nonpersistent_flags+=("--build-tags=")
    flags+=("--timeout=")
    two_word_flags+=("--timeout")
    local_nonpersistent_flags+=("--timeout=")
    flags+=("--tests")
    local_nonpersistent_flags+=("--tests")
    flags+=("--print-resources-usage")
    local_nonpersistent_flags+=("--print-resources-usage")
    flags+=("--config=")
    two_word_flags+=("--config")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--config=")
    flags+=("--no-config")
    local_nonpersistent_flags+=("--no-config")
    flags+=("--skip-dirs=")
    two_word_flags+=("--skip-dirs")
    local_nonpersistent_flags+=("--skip-dirs=")
    flags+=("--skip-dirs-use-default")
    local_nonpersistent_flags+=("--skip-dirs-use-default")
    flags+=("--skip-files=")
    two_word_flags+=("--skip-files")
    local_nonpersistent_flags+=("--skip-files=")
    flags+=("--enable=")
    two_word_flags+=("--enable")
    two_word_flags+=("-E")
    local_nonpersistent_flags+=("--enable=")
    flags+=("--disable=")
    two_word_flags+=("--disable")
    two_word_flags+=("-D")
    local_nonpersistent_flags+=("--disable=")
    flags+=("--disable-all")
    local_nonpersistent_flags+=("--disable-all")
    flags+=("--presets=")
    two_word_flags+=("--presets")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--presets=")
    flags+=("--fast")
    local_nonpersistent_flags+=("--fast")
    flags+=("--exclude=")
    two_word_flags+=("--exclude")
    two_word_flags+=("-e")
    local_nonpersistent_flags+=("--exclude=")
    flags+=("--exclude-use-default")
    local_nonpersistent_flags+=("--exclude-use-default")
    flags+=("--max-issues-per-linter=")
    two_word_flags+=("--max-issues-per-linter")
    local_nonpersistent_flags+=("--max-issues-per-linter=")
    flags+=("--max-same-issues=")
    two_word_flags+=("--max-same-issues")
    local_nonpersistent_flags+=("--max-same-issues=")
    flags+=("--new")
    flags+=("-n")
    local_nonpersistent_flags+=("--new")
    flags+=("--new-from-rev=")
    two_word_flags+=("--new-from-rev")
    local_nonpersistent_flags+=("--new-from-rev=")
    flags+=("--new-from-patch=")
    two_word_flags+=("--new-from-patch")
    local_nonpersistent_flags+=("--new-from-patch=")
    flags+=("--fix")
    local_nonpersistent_flags+=("--fix")
    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_version()
{
    last_command="golangci-lint_version"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_golangci-lint_root_command()
{
    last_command="golangci-lint"

    command_aliases=()

    commands=()
    commands+=("cache")
    commands+=("completion")
    commands+=("config")
    commands+=("linters")
    commands+=("run")
    commands+=("version")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--color=")
    two_word_flags+=("--color")
    flags+=("--concurrency=")
    two_word_flags+=("--concurrency")
    two_word_flags+=("-j")
    flags+=("--cpu-profile-path=")
    two_word_flags+=("--cpu-profile-path")
    flags+=("--mem-profile-path=")
    two_word_flags+=("--mem-profile-path")
    flags+=("--trace-path=")
    two_word_flags+=("--trace-path")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--version")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_golangci-lint()
{
    local cur prev words cword
    declare -A flaghash 2>/dev/null || :
    declare -A aliashash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __golangci-lint_init_completion -n "=" || return
    fi

    local c=0
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("golangci-lint")
    local must_have_one_flag=()
    local must_have_one_noun=()
    local last_command
    local nouns=()

    __golangci-lint_handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_golangci-lint golangci-lint
else
    complete -o default -o nospace -F __start_golangci-lint golangci-lint
fi

# ex: ts=4 sw=4 et filetype=sh
