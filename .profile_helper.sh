#!/bin/bash

echo_red()
{
    echo -e "\033[31m$@\033[0m"
}

echo_green()
{
    echo -e "\033[32m$@\033[0m"
}

echo_green()
{
    echo -e "\033[32m$@\033[0m"
}

# grep in .git dir
ggrep()
{
    if [ -d "./.git" ] ; then
        find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.*" -print0 | xargs -0 grep --color -n "$@"
    else
        echo "not a git dir."
    fi
}

dgrep()
{
    grep "$@" -nr .
}

dfind()
{
    find . -name "$@"
}

chgrep()
{
    find . -name "*.[ch]" | xargs -n 1 grep --color=auto -Hnr "$@"
}

# http://www.ibm.com/developerworks/cn/linux/l-bash-parameters.html

git_repo_merge() {
    src_path=$1
    dest_path=$2
}

# find_suffix_in_dir ${dir} ${suffix}
find_suffix_in_dir() {
    dir=$1
    suffix=$2
    echo $(find $dir -name *$suffix 2>/dev/null)
}

# verify dir was git repo
verify_git_repo_dir() {
    dir=$1

    if [ -d $dir ]; then
	if [ -f $dir/config ]; then
	    echo 0
	elif [ -f $dir/.git/config ]; then
	    echo 1
	else
	    echo -1
	fi
    else
	echo -100
    fi
}

# get_git_repo_list dir path, list_file path name
get_git_repo_list() {
    find_dir=${1:-.}
    list_file=${2:-git_list.txt}
    > $list_file

    repo_git=$(find_suffix_in_dir $find_dir .git)
    for _git in $repo_git
    do
	work_tree=
	git_dir=$_git
	verify=$(verify_git_repo_dir $git_dir)
	if [ $verify -eq 0 ]; then
	    git_remote=$(git --git-dir $git_dir remote -v | grep fetch | awk '{print $2}')
	    echo "$(dirname $git_dir) $git_remote" >> $list_file
	else
	    echo $git_dir is not a git repo, error code $verify
	fi
    done
}

_gettop()
{
    local TOPFILE=$1

    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        echo $TOP
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            # We redirect cd to /dev/null in case it's aliased to
            # a command that prints something as a side-effect
            # (like pushd)
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                cd .. > /dev/null
                #T=`PWD= /bin/pwd`
                T=$PWD
            done
            cd $HERE > /dev/null
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

cd_git_top_dir() {
    cd $(_gettop ".git/config")
}
