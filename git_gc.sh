expire=1.second.ago
#expire=now
auto=1

repack_all_option='';
#gc_auto_threshold=6700;
gc_auto_threshold=1;
#gc_auto_pack_limit=50;
gc_auto_pack_limit=1;

function add_repack_all_option() {
    if [ "now" == "${expire}" ]; then
        repack_all_option="-a";
    else
        repack_all_option="-A --unpack-unreachable=${expire}";
    fi
}

function _add_fork_commit_lists() {
    # todo: most of the result is referenced, need to reduce?
    for frk in $@; do
        # show heads of all remotes, its is a o(n) search
        git --git-dir="${frk}"/.git --work-tree="${frk}" rev-parse --remotes;
    done
}

function too_many_packs() {
    local repo="$1";
    local objdir="${repo}"/.git/objects;
    if [ ${gc_auto_pack_limit} -le 0 ]; then
        return 0;
    fi
    local count=0;
    # get amount of local packs, it is a little bit difficult to implement this function in python
    # now what i can do is to read "GIT_DIR/objects/info/packs and count amount of line
    if [ -r "${objdir}"/info/packs ]; then
        count=$(cat "${objdir}"/info/packs | wc -l)
        count=$(expr ${count} - 1)
    fi
    if [ ${count} -ge ${gc_auto_pack_limit} ]; then
        return 1;
    fi
    return 0;
}

function too_many_loose_objects() {
    local repo="$1";
    local objdir="${repo}"/.git/objects;
    if [ ${gc_auto_threshold} -le 0 ]; then
        return 0;
    fi
    # check only one and get a reasonable estimate to amount of loose objects.
    local auto_threshold=$(expr $(expr ${gc_auto_threshold} + 255) / 256);
    log_print "${FUNCNAME}" "auto_threshold <- ${auto_threshold}"
    local dir=$(ls "${objdir}" | head -1);
    local path="${objdir}/${dir}";
    local count=0;
    if [ -d "${path}" ]; then
        for i in $(ls "${path}"); do
            if [ $(strspn $i "0123456789abcdef") -eq 38 ] && [ ${#i} -eq 38 ]; then
                count=$(expr ${count} + 1);
            fi
        done
    fi
    log_print "${FUNCNAME}" "count <- ${count}"
    if [ ${count} -gt ${auto_threshold} ]; then
        return 1;
    fi
    return 0;
}

function need_to_gc() {
    local repo="$1";
    if [ ${gc_auto_threshold} -le 0 ]; then
        return 0;
    fi
    too_many_packs "${repo}";
    if [ 0 -ne $? ]; then
        log_print "${FUNCNAME}" "too_many_packs <- true"
        add_repack_all_option;
    else
        log_print "${FUNCNAME}" "too_many_packs <- false"
        too_many_loose_objects "${repo}";
        if [ 0 -eq $? ]; then
            log_print "${FUNCNAME}" "too_many_loose_objects <- false"
            return 0;
        fi
        log_print "${FUNCNAME}" "too_many_loose_objects <- true"
    fi

    ## todo: run a hook?
    #if [ $(run_hook "pre-auto-gc") ]; then
    #return 0;
    #fi
    return 1;
}

function add_fork_commit_lists() {
    # remove same results
    _add_fork_commit_lists $@ | sort | uniq;
}

function do_multi_gc() {
    local src="$1";
    shift;
    if [ 0 -ne ${auto} ]; then
        log_print "${FUNCNAME}" "auto <- true"
        need_to_gc "${src}";
        if [ 0 -eq $? ]; then
            log_print "${FUNCNAME}" "need_to_gc <- false"
            return 0;
        fi
    else
        log_print "${FUNCNAME}" "auto <- false"
        add_repack_all_option;
    fi
    # pack references
    git --git-dir="${src}"/.git --work-tree="${src}" pack-refs --all --prune;
    # remove unreachable reflog
    git --git-dir="${src}"/.git --work-tree="${src}" reflog expire --all;
    # repack
    git --git-dir="${src}"/.git --work-tree="${src}" repack -d -l ${repack_all_option};
    # remove unreferenced objects
    # with add_fork_commit_lists display all remotes in forks, in fact, most of them are same.
    # in Ellen, wu can use pygit2 to require head's SHA-1 value of all remote branches in each fork.
    # prune will keep objects reachable from listed <head>s besides any of references in this repo.
    local fork_commit_list="$(add_fork_commit_lists $@)"
    log_print "${FUNCNAME}" "fork_commit_list <- ${fork_commit_list}"
    git --git-dir="${src}"/.git --work-tree="${src}" prune --expire "${expire}" \
        ${fork_commit_list}
    # reuse recorded resolution
    git --git-dir="${src}"/.git --work-tree="${src}" rerere gc;
    return 0;
}
