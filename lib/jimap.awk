
function jkp( ){
    return "\"" gsub(KSE{, ""})
}

# Section: jiter
BEGIN{
    JITER_LEVEL = 1
    JITER_STACK[ 1 ] = ""   # keypath
}

function init_jimap(){
    JITER_FA_KEYPATH = ""
    JITER_STATE = T_ROOT
    JITER_LAST_KP = ""
    JITER_LEVEL = 1
    JITER_STACK[ 1 ] = ""
    JITER_CURLEN = 0

    JITER_LAST_KL = ""

    JITER_TARGET_LEVEL = 0
    JITER_TARGET_LAST_KP = ""
    JITER_TARGET_STATE = T_ROOT
    JITER_TARGET_LEVEL = 0
    JITER_TARGET_CURLEN = 0
    # JITER_TARGET_STACK [ 1 ] = ""

}

# example code
function handle( item ){
    if ( jimap( item, target_keypath ) == 0 ) return
    if ( jimap_target_parse_( item ) > 0 ) return

    # do something for _
    # jstr( _ )
    delete _
}

{
    handle( $0, target_keypath )
}

# Section: target handler for print

# There is no handle_print, because if you want to format the output, pipe to another formatter
function handle_print1(){
    if ( jimap( item, target_keypath ) == 0 ) return
    jimap_target_levelcal( item )
    printf("%s", item)
    if (JITER_TARGET_LEVEL == 0) {
        printf("\n")
    }
}

function handle_print0(){
    if ( jimap( item, target_keypath ) == 0 ) return
    jimap_target_levelcal( item )
    printf("%s\n", item)
}

function jimap_target_levelcal( item ){
    if (item !~ /^[\[\]\{\}]$/ ) {
        if (JITER_TARGET_LEVEL == 1) {
            JITER_TARGET_LEVEL = 0
        }
    } else if (item ~ /^[\[\{]$/) {
        JITER_TARGET_LEVEL += 1
    } else if (item ~ /^[\]\}]$/) {
        JITER_TARGET_LEVEL -= 1
        if (JITER_TARGET_LEVEL == 1) {
            JITER_TARGET_LEVEL = 0
        }
    }
    return JITER_TARGET_LEVEL
}

# EndSection

function jimap_target_parse_( item ){
    return jimap_target_parse(_, item)
}

function jimap_target_parse( obj, item ){

}
# EndSection

# Section: jimap core
function jimap( item, target_keypath_regex ){

    if (JITER_TARGET_LEVEL > 0) {
        return false
    }

    if (item ~ /^[,:]*$/) {
        return JITER_TARGET_LEVEL
    } else if (item ~ /^[tfn"0-9+-]/) { #"
    # } else if (item !~ /^[\{\}\[\]]$/) {
        JITER_CURLEN = JITER_CURLEN + 1
        if ( JITER_STATE == T_DICT ) {
            if ( JITER_LAST_KP != "" ) {
                JITER_CURLEN = JITER_CURLEN - 1
                JITER_LAST_KP = ""
            } else {
                JITER_LAST_KP = item
            }
        }

        # Special code
        match(JITER_FA_KEYPATH, target_keypath_regex)
        if (RLENGTH > 0) {
            JITER_TARGET_LEVEL = 1
        }
        # End

    } else if (item ~ /^\[$/) {
        if ( JITER_STATE != T_DICT ) {
            JITER_CURLEN = JITER_CURLEN + 1
            JITER_STACK[ JITER_FA_KEYPATH T_LEN ] = JITER_CURLEN
            JITER_FA_KEYPATH = JITER_FA_KEYPATH S "\"" JITER_CURLEN "\""
        } else {
            JITER_STACK[ JITER_FA_KEYPATH T_LEN ] = JITER_CURLEN
            JITER_FA_KEYPATH = JITER_FA_KEYPATH S JITER_LAST_KP
            JITER_LAST_KP = ""
        }

        # Special code
        match(JITER_FA_KEYPATH, target_keypath_regex)
        if (RLENGTH > 0) {
            JITER_TARGET_LEVEL = 1
        }
        # End

        JITER_STATE = T_LIST
        JITER_CURLEN = 0

        JITER_STACK[ JITER_FA_KEYPATH ] = T_LIST

        JITER_STACK[ ++JITER_LEVEL ] = JITER_FA_KEYPATH
    } else if (item ~ /^\]$/) {
        JITER_STACK[ JITER_FA_KEYPATH T_LEN ] = JITER_CURLEN

        JITER_LEVEL --

        JITER_FA_KEYPATH = JITER_STACK[ JITER_LEVEL ]
        JITER_STATE = obj[ JITER_FA_KEYPATH ]
        JITER_CURLEN = obj[ JITER_FA_KEYPATH T_LEN ]
    } else if (item ~ /^\{$/) {
        if ( JITER_STATE != T_DICT ) {
            JITER_CURLEN = JITER_CURLEN + 1
            JITER_STACK[ JITER_FA_KEYPATH T_LEN ] = JITER_CURLEN
            JITER_FA_KEYPATH = JITER_FA_KEYPATH S "\"" JITER_CURLEN "\""
        } else {
            JITER_STACK[ JITER_FA_KEYPATH T_LEN ] = JITER_CURLEN
            JITER_FA_KEYPATH = JITER_FA_KEYPATH S JITER_LAST_KP
            JITER_LAST_KP = ""
        }

        # Special code
        match(JITER_FA_KEYPATH, target_keypath_regex)
        if (RLENGTH > 0) {
            JITER_TARGET_LEVEL = 1
        }
        # End

        JITER_STATE = T_DICT
        JITER_CURLEN = 0

        JITER_STACK[ JITER_FA_KEYPATH ] = T_DICT

        JITER_STACK[ ++JITER_LEVEL ] = JITER_FA_KEYPATH
    } else if (item ~ /^\}$/) {
        JITER_STACK[ JITER_FA_KEYPATH T_LEN ] = JITER_CURLEN

        JITER_LEVEL --

        JITER_FA_KEYPATH = JITER_STACK[ JITER_LEVEL ]
        JITER_STATE = JITER_STACK[ JITER_FA_KEYPATH ]
        JITER_CURLEN = JITER_STACK[ JITER_FA_KEYPATH T_LEN ]
    }

    return JITER_TARGET_LEVEL
}
# EndSection


# BEGIN{
#     jimap_setup( json_kp("work", 1, "handle", "a") )
# }

# {
#     if ( jimap( token, json_kp("work", 1, "handle", "a") ) ){
#         return
#     }

#     jimap_get("a" KSEP "b")
#     jimap_get_raw("a" KSEP "b")

# }



# Section: jiter other extract design

# BEGIN{

#     if (false == jiter_handle_when_kp_eq(token, json_kp("work", 1, "handle", "a") )){
#         return
#     }

#     if (false == jiter_handle_when_kp_partof(token, json_kp("work", 1, "handle", "a") )){
#         return
#     }

#     if (false == jiter_handle_when_kp_hasprefix(token, json_kp("work", 1, "handle", "a") )){
#         return
#     }

#     JITER_KP = work
#     JITER_KEY = 1
#     JITER_KEY = 1
#     JITER_VAL = 2

#     if ( true == json_kp_has( JITER_KEY, json_kp(1, "handle", "a", "1", "work") ) ) {

#     }

#     if ( true == json_kp_has( JITER_KEY, json_kp(1, "handle", "a", "1", "work") ) ) {

#     }

# }


# EndSection
