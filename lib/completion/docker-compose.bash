#!bash
#
# bash completion for docker-compose
#
# This work is based on the completion for the docker command.
#
# This script provides completion of:
#  - commands and their options
#  - service names
#  - filepaths
#
# To enable the completions either:
#  - place this file in /etc/bash_completion.d
#  or
#  - copy this file to e.g. ~/.docker-compose-completion.sh and add the line
#    below to your .bashrc after bash completion features are loaded
#    . ~/.docker-compose-completion.sh


# suppress trailing whitespace
__docker_compose_nospace() {
	# compopt is not available in ancient bash versions
	type compopt &>/dev/null && compopt -o nospace
}

# For compatibility reasons, Compose and therefore its completion supports several
# stack compositon files as listed here, in descending priority.
# Support for these filenames might be dropped in some future version.
__docker_compose_compose_file() {
	local file
	for file in docker-compose.y{,a}ml fig.y{,a}ml ; do
		[ -e $file ] && {
			echo $file
			return
		}
	done
	echo docker-compose.yml
}

# Extracts all service names from the compose file.
___docker_compose_all_services_in_compose_file() {
	awk -F: '/^[a-zA-Z0-9]/{print $1}' "${compose_file:-$(__docker_compose_compose_file)}" 2>/dev/null
}

# All services, even those without an existing container
__docker_compose_services_all() {
	COMPREPLY=( $(compgen -W "$(___docker_compose_all_services_in_compose_file)" -- "$cur") )
}

# All services that have an entry with the given key in their compose_file section
___docker_compose_services_with_key() {
	# flatten sections to one line, then filter lines containing the key and return section name.
	awk '/^[a-zA-Z0-9]/{printf "\n"};{printf $0;next;}' "${compose_file:-$(__docker_compose_compose_file)}" 2>/dev/null | awk -F: -v key=": +$1:" '$0 ~ key {print $1}'
}

# All services that are defined by a Dockerfile reference
__docker_compose_services_from_build() {
	COMPREPLY=( $(compgen -W "$(___docker_compose_services_with_key build)" -- "$cur") )
}

# All services that are defined by an image
__docker_compose_services_from_image() {
	COMPREPLY=( $(compgen -W "$(___docker_compose_services_with_key image)" -- "$cur") )
}

# The services for which containers have been created, optionally filtered
# by a boolean expression passed in as argument.
__docker_compose_services_with() {
	local containers names
	containers="$(docker-compose 2>/dev/null ${compose_file:+-f $compose_file} ${compose_project:+-p $compose_project} ps -q)"
	names=( $(docker 2>/dev/null inspect --format "{{if ${1:-true}}} {{ .Name }} {{end}}" $containers) )
	names=( ${names[@]%_*} )  # strip trailing numbers
	names=( ${names[@]#*_} )  # strip project name
	COMPREPLY=( $(compgen -W "${names[*]}" -- "$cur") )
}

# The services for which at least one paused container exists
__docker_compose_services_paused() {
	__docker_compose_services_with '.State.Paused'
}

# The services for which at least one running container exists
__docker_compose_services_running() {
	__docker_compose_services_with '.State.Running'
}

# The services for which at least one stopped container exists
__docker_compose_services_stopped() {
	__docker_compose_services_with 'not .State.Running'
}


_docker_compose_build() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--force-rm --help --no-cache --pull" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_from_build
			;;
	esac
}


_docker_compose_docker_compose() {
	case "$prev" in
		--file|-f)
			_filedir "y?(a)ml"
			return
			;;
		--project-name|-p)
			return
			;;
		--x-network-driver)
			COMPREPLY=( $( compgen -W "bridge host none overlay" -- "$cur" ) )
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--file -f --help -h --project-name -p --verbose --version -v --x-networking --x-network-driver" -- "$cur" ) )
			;;
		*)
			COMPREPLY=( $( compgen -W "${commands[*]}" -- "$cur" ) )
			;;
	esac
}


_docker_compose_help() {
	COMPREPLY=( $( compgen -W "${commands[*]}" -- "$cur" ) )
}


_docker_compose_kill() {
	case "$prev" in
		-s)
			COMPREPLY=( $( compgen -W "SIGHUP SIGINT SIGKILL SIGUSR1 SIGUSR2" -- "$(echo $cur | tr '[:lower:]' '[:upper:]')" ) )
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help -s" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_running
			;;
	esac
}


_docker_compose_logs() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help --no-color" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_all
			;;
	esac
}


_docker_compose_migrate_to_labels() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help" -- "$cur" ) )
			;;
	esac
}


_docker_compose_pause() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_running
			;;
	esac
}


_docker_compose_port() {
	case "$prev" in
		--protocol)
			COMPREPLY=( $( compgen -W "tcp udp" -- "$cur" ) )
			return;
			;;
		--index)
			return;
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help --index --protocol" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_all
			;;
	esac
}


_docker_compose_ps() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help -q" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_all
			;;
	esac
}


_docker_compose_pull() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help --ignore-pull-failures" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_from_image
			;;
	esac
}


_docker_compose_restart() {
	case "$prev" in
		--timeout|-t)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help --timeout -t" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_running
			;;
	esac
}


_docker_compose_rm() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--force -f --help -v" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_stopped
			;;
	esac
}


_docker_compose_run() {
	case "$prev" in
		-e)
			COMPREPLY=( $( compgen -e -- "$cur" ) )
			__docker_compose_nospace
			return
			;;
		--entrypoint|--name|--user|-u)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "-d --entrypoint -e --help --name --no-deps --publish -p --rm --service-ports -T --user -u" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_all
			;;
	esac
}


_docker_compose_scale() {
	case "$prev" in
		=)
			COMPREPLY=("$cur")
			return
			;;
		--timeout|-t)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help --timeout -t" -- "$cur" ) )
			;;
		*)
			COMPREPLY=( $(compgen -S "=" -W "$(___docker_compose_all_services_in_compose_file)" -- "$cur") )
			__docker_compose_nospace
			;;
	esac
}


_docker_compose_start() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_stopped
			;;
	esac
}


_docker_compose_stop() {
	case "$prev" in
		--timeout|-t)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help --timeout -t" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_running
			;;
	esac
}


_docker_compose_unpause() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_paused
			;;
	esac
}


_docker_compose_up() {
	case "$prev" in
		--timeout|-t)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "-d --help --no-build --no-color --no-deps --no-recreate --force-recreate --timeout -t" -- "$cur" ) )
			;;
		*)
			__docker_compose_services_all
			;;
	esac
}


_docker_compose_version() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--short" -- "$cur" ) )
			;;
	esac
}


_docker_compose() {
	local previous_extglob_setting=$(shopt -p extglob)
	shopt -s extglob

	local commands=(
		build
		help
		kill
		logs
		migrate-to-labels
		pause
		port
		ps
		pull
		restart
		rm
		run
		scale
		start
		stop
		unpause
		up
		version
	)

	COMPREPLY=()
	local cur prev words cword
	_get_comp_words_by_ref -n : cur prev words cword

	# search subcommand and invoke its handler.
	# special treatment of some top-level options
	local command='docker_compose'
	local counter=1
	local compose_file compose_project
	while [ $counter -lt $cword ]; do
		case "${words[$counter]}" in
			--file|-f)
				(( counter++ ))
				compose_file="${words[$counter]}"
				;;
			--project-name|p)
				(( counter++ ))
				compose_project="${words[$counter]}"
				;;
			--x-network-driver)
				(( counter++ ))
				;;
			-*)
				;;
			*)
				command="${words[$counter]}"
				break
				;;
		esac
		(( counter++ ))
	done

	local completions_func=_docker_compose_${command//-/_}
	declare -F $completions_func >/dev/null && $completions_func

	eval "$previous_extglob_setting"
	return 0
}

complete -F _docker_compose docker-compose
