# bash completion for hugo                                 -*- shell-script -*-

__debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Homebrew on Macs have version 1.3 of bash-completion which doesn't include
# _init_completion. This is a very minimal version of that function.
__my_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__index_of_word()
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

__contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__handle_reply()
{
    __debug "${FUNCNAME[0]}"
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
                flag="${cur%%=*}"
                __index_of_word "${flag}" "${flags_with_completion[@]}"
                COMPREPLY=()
                if [[ ${index} -ge 0 ]]; then
                    PREFIX=""
                    cur="${cur#*=}"
                    ${flags_completion[${index}]}
                    if [ -n "${ZSH_VERSION}" ]; then
                        # zfs completion needs --flag= prefix
                        eval "COMPREPLY=( \"\${COMPREPLY[@]/#/${flag}=}\" )"
                    fi
                fi
            fi
            return 0;
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __index_of_word "${prev}" "${flags_with_completion[@]}"
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
        declare -F __custom_func >/dev/null && __custom_func
    fi

    # available in bash-completion >= 2, not always present on macOS
    if declare -F __ltrim_colon_completions >/dev/null; then
        __ltrim_colon_completions "$cur"
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__handle_subdirs_in_dir_flag()
{
    local dir="$1"
    pushd "${dir}" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1
}

__handle_flag()
{
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    local flagvalue
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagvalue=${flagname#*=} # take in as flagvalue after the =
        flagname=${flagname%%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __debug "${FUNCNAME[0]}: looking for ${flagname}"
    if __contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # if you set a flag which only applies to this command, don't show subcommands
    if __contains_word "${flagname}" "${local_nonpersistent_flags[@]}"; then
      commands=()
    fi

    # keep flag value with flagname as flaghash
    if [ -n "${flagvalue}" ] ; then
        flaghash[${flagname}]=${flagvalue}
    elif [ -n "${words[ $((c+1)) ]}" ] ; then
        flaghash[${flagname}]=${words[ $((c+1)) ]}
    else
        flaghash[${flagname}]="true" # pad "true" for bool flag
    fi

    # skip the argument to a two word flag
    if __contains_word "${words[c]}" "${two_word_flags[@]}"; then
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    c=$((c+1))

}

__handle_noun()
{
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    if __contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    elif __contains_word "${words[c]}" "${noun_aliases[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__handle_command()
{
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_$(basename "${words[c]//:/__}")"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    __debug "${FUNCNAME[0]}: looking for ${next_command}"
    declare -F "$next_command" >/dev/null && $next_command
}

__handle_word()
{
    if [[ $c -ge $cword ]]; then
        __handle_reply
        return
    fi
    __debug "${FUNCNAME[0]}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
        __handle_flag
    elif __contains_word "${words[c]}" "${commands[@]}"; then
        __handle_command
    elif [[ $c -eq 0 ]] && __contains_word "$(basename "${words[c]}")" "${commands[@]}"; then
        __handle_command
    else
        __handle_noun
    fi
    __handle_word
}

_hugo_benchmark()
{
    last_command="hugo_benchmark"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--baseURL=")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL=")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    flags+=("--cacheDir=")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--canonifyURLs")
    local_nonpersistent_flags+=("--canonifyURLs")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--contentDir=")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir=")
    flags+=("--count=")
    two_word_flags+=("-n")
    local_nonpersistent_flags+=("--count=")
    flags+=("--cpuprofile=")
    local_nonpersistent_flags+=("--cpuprofile=")
    flags+=("--destination=")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination=")
    flags+=("--disable404")
    local_nonpersistent_flags+=("--disable404")
    flags+=("--disableKinds=")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--disableRSS")
    local_nonpersistent_flags+=("--disableRSS")
    flags+=("--disableSitemap")
    local_nonpersistent_flags+=("--disableSitemap")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--layoutDir=")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir=")
    flags+=("--memprofile=")
    local_nonpersistent_flags+=("--memprofile=")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--pluralizeListTitles")
    local_nonpersistent_flags+=("--pluralizeListTitles")
    flags+=("--preserveTaxonomyNames")
    local_nonpersistent_flags+=("--preserveTaxonomyNames")
    flags+=("--renderToMemory")
    local_nonpersistent_flags+=("--renderToMemory")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--source=")
    flags+=("--stepAnalysis")
    local_nonpersistent_flags+=("--stepAnalysis")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    flags_with_completion+=("--theme")
    flags_completion+=("__handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme=")
    flags+=("--themesDir=")
    local_nonpersistent_flags+=("--themesDir=")
    flags+=("--uglyURLs")
    local_nonpersistent_flags+=("--uglyURLs")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_config()
{
    last_command="hugo_config"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert_toJSON()
{
    last_command="hugo_convert_toJSON"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--unsafe")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert_toTOML()
{
    last_command="hugo_convert_toTOML"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--unsafe")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert_toYAML()
{
    last_command="hugo_convert_toYAML"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--unsafe")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_convert()
{
    last_command="hugo_convert"
    commands=()
    commands+=("toJSON")
    commands+=("toTOML")
    commands+=("toYAML")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--unsafe")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_env()
{
    last_command="hugo_env"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_autocomplete()
{
    last_command="hugo_gen_autocomplete"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--completionfile=")
    flags_with_completion+=("--completionfile")
    flags_completion+=("_filedir")
    flags+=("--help")
    flags+=("-h")
    local_nonpersistent_flags+=("--help")
    flags+=("--type=")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_chromastyles()
{
    last_command="hugo_gen_chromastyles"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--highlightStyle=")
    flags+=("--linesStyle=")
    flags+=("--style=")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_doc()
{
    last_command="hugo_gen_doc"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    flags_with_completion+=("--dir")
    flags_completion+=("_filedir -d")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen_man()
{
    last_command="hugo_gen_man"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    flags_with_completion+=("--dir")
    flags_completion+=("_filedir -d")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_gen()
{
    last_command="hugo_gen"
    commands=()
    commands+=("autocomplete")
    commands+=("chromastyles")
    commands+=("doc")
    commands+=("man")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_import_jekyll()
{
    last_command="hugo_import_jekyll"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_import()
{
    last_command="hugo_import"
    commands=()
    commands+=("jekyll")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_drafts()
{
    last_command="hugo_list_drafts"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_expired()
{
    last_command="hugo_list_expired"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list_future()
{
    last_command="hugo_list_future"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_list()
{
    last_command="hugo_list"
    commands=()
    commands+=("drafts")
    commands+=("expired")
    commands+=("future")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_new_site()
{
    last_command="hugo_new_site"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--force")
    local_nonpersistent_flags+=("--force")
    flags+=("--format=")
    two_word_flags+=("-f")
    local_nonpersistent_flags+=("--format=")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_new_theme()
{
    last_command="hugo_new_theme"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_new()
{
    last_command="hugo_new"
    commands=()
    commands+=("site")
    commands+=("theme")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--editor=")
    local_nonpersistent_flags+=("--editor=")
    flags+=("--kind=")
    two_word_flags+=("-k")
    local_nonpersistent_flags+=("--kind=")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_server()
{
    last_command="hugo_server"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--appendPort")
    local_nonpersistent_flags+=("--appendPort")
    flags+=("--baseURL=")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL=")
    flags+=("--bind=")
    local_nonpersistent_flags+=("--bind=")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    flags+=("--cacheDir=")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--canonifyURLs")
    local_nonpersistent_flags+=("--canonifyURLs")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--contentDir=")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir=")
    flags+=("--destination=")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination=")
    flags+=("--disable404")
    local_nonpersistent_flags+=("--disable404")
    flags+=("--disableFastRender")
    local_nonpersistent_flags+=("--disableFastRender")
    flags+=("--disableKinds=")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--disableLiveReload")
    local_nonpersistent_flags+=("--disableLiveReload")
    flags+=("--disableRSS")
    local_nonpersistent_flags+=("--disableRSS")
    flags+=("--disableSitemap")
    local_nonpersistent_flags+=("--disableSitemap")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--layoutDir=")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir=")
    flags+=("--liveReloadPort=")
    local_nonpersistent_flags+=("--liveReloadPort=")
    flags+=("--meminterval=")
    local_nonpersistent_flags+=("--meminterval=")
    flags+=("--memstats=")
    local_nonpersistent_flags+=("--memstats=")
    flags+=("--navigateToChanged")
    local_nonpersistent_flags+=("--navigateToChanged")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noHTTPCache")
    local_nonpersistent_flags+=("--noHTTPCache")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--pluralizeListTitles")
    local_nonpersistent_flags+=("--pluralizeListTitles")
    flags+=("--port=")
    two_word_flags+=("-p")
    local_nonpersistent_flags+=("--port=")
    flags+=("--preserveTaxonomyNames")
    local_nonpersistent_flags+=("--preserveTaxonomyNames")
    flags+=("--renderToDisk")
    local_nonpersistent_flags+=("--renderToDisk")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--source=")
    flags+=("--stepAnalysis")
    local_nonpersistent_flags+=("--stepAnalysis")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    flags_with_completion+=("--theme")
    flags_completion+=("__handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme=")
    flags+=("--themesDir=")
    local_nonpersistent_flags+=("--themesDir=")
    flags+=("--uglyURLs")
    local_nonpersistent_flags+=("--uglyURLs")
    flags+=("--watch")
    flags+=("-w")
    local_nonpersistent_flags+=("--watch")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_undraft()
{
    last_command="hugo_undraft"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo_version()
{
    last_command="hugo_version"
    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--debug")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--quiet")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

_hugo()
{
    last_command="hugo"
    commands=()
    commands+=("benchmark")
    commands+=("config")
    commands+=("convert")
    commands+=("env")
    commands+=("gen")
    commands+=("import")
    commands+=("list")
    commands+=("new")
    commands+=("server")
    commands+=("undraft")
    commands+=("version")

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--baseURL=")
    two_word_flags+=("-b")
    local_nonpersistent_flags+=("--baseURL=")
    flags+=("--buildDrafts")
    flags+=("-D")
    local_nonpersistent_flags+=("--buildDrafts")
    flags+=("--buildExpired")
    flags+=("-E")
    local_nonpersistent_flags+=("--buildExpired")
    flags+=("--buildFuture")
    flags+=("-F")
    local_nonpersistent_flags+=("--buildFuture")
    flags+=("--cacheDir=")
    flags_with_completion+=("--cacheDir")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--cacheDir=")
    flags+=("--canonifyURLs")
    local_nonpersistent_flags+=("--canonifyURLs")
    flags+=("--cleanDestinationDir")
    local_nonpersistent_flags+=("--cleanDestinationDir")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--contentDir=")
    two_word_flags+=("-c")
    local_nonpersistent_flags+=("--contentDir=")
    flags+=("--debug")
    flags+=("--destination=")
    flags_with_completion+=("--destination")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-d")
    flags_with_completion+=("-d")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--destination=")
    flags+=("--disable404")
    local_nonpersistent_flags+=("--disable404")
    flags+=("--disableKinds=")
    local_nonpersistent_flags+=("--disableKinds=")
    flags+=("--disableRSS")
    local_nonpersistent_flags+=("--disableRSS")
    flags+=("--disableSitemap")
    local_nonpersistent_flags+=("--disableSitemap")
    flags+=("--enableGitInfo")
    local_nonpersistent_flags+=("--enableGitInfo")
    flags+=("--forceSyncStatic")
    local_nonpersistent_flags+=("--forceSyncStatic")
    flags+=("--i18n-warnings")
    local_nonpersistent_flags+=("--i18n-warnings")
    flags+=("--ignoreCache")
    local_nonpersistent_flags+=("--ignoreCache")
    flags+=("--layoutDir=")
    two_word_flags+=("-l")
    local_nonpersistent_flags+=("--layoutDir=")
    flags+=("--log")
    flags+=("--logFile=")
    flags_with_completion+=("--logFile")
    flags_completion+=("_filedir")
    flags+=("--noChmod")
    local_nonpersistent_flags+=("--noChmod")
    flags+=("--noTimes")
    local_nonpersistent_flags+=("--noTimes")
    flags+=("--pluralizeListTitles")
    local_nonpersistent_flags+=("--pluralizeListTitles")
    flags+=("--preserveTaxonomyNames")
    local_nonpersistent_flags+=("--preserveTaxonomyNames")
    flags+=("--quiet")
    flags+=("--renderToMemory")
    local_nonpersistent_flags+=("--renderToMemory")
    flags+=("--source=")
    flags_with_completion+=("--source")
    flags_completion+=("_filedir -d")
    two_word_flags+=("-s")
    flags_with_completion+=("-s")
    flags_completion+=("_filedir -d")
    local_nonpersistent_flags+=("--source=")
    flags+=("--stepAnalysis")
    local_nonpersistent_flags+=("--stepAnalysis")
    flags+=("--templateMetrics")
    local_nonpersistent_flags+=("--templateMetrics")
    flags+=("--templateMetricsHints")
    local_nonpersistent_flags+=("--templateMetricsHints")
    flags+=("--theme=")
    flags_with_completion+=("--theme")
    flags_completion+=("__handle_subdirs_in_dir_flag themes")
    two_word_flags+=("-t")
    flags_with_completion+=("-t")
    flags_completion+=("__handle_subdirs_in_dir_flag themes")
    local_nonpersistent_flags+=("--theme=")
    flags+=("--themesDir=")
    local_nonpersistent_flags+=("--themesDir=")
    flags+=("--uglyURLs")
    local_nonpersistent_flags+=("--uglyURLs")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")
    flags+=("--watch")
    flags+=("-w")
    local_nonpersistent_flags+=("--watch")

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}

__start_hugo()
{
    local cur prev words cword
    declare -A flaghash 2>/dev/null || :
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -s || return
    else
        __my_init_completion -n "=" || return
    fi

    local c=0
    local flags=()
    local two_word_flags=()
    local local_nonpersistent_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("hugo")
    local must_have_one_flag=()
    local must_have_one_noun=()
    local last_command
    local nouns=()

    __handle_word
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_hugo hugo
else
    complete -o default -o nospace -F __start_hugo hugo
fi

# ex: ts=4 sw=4 et filetype=sh
