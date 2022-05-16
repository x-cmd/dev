

END {
    prefix = jqu(PKG_NAME) SUBSEP jqu("url") SUBSEP jqu( NET_REGION )
    if ( "[" != table[ prefix ] ) {
        print table_eval(table, PKG_NAME, table[ prefix ])
    } else {
        l = table[ prefix L ]
        for (i=1; i<=l; ++i) {
            print table_eval(table, PKG_NAME, table[ prefix, i ] )
        }
    }
}


