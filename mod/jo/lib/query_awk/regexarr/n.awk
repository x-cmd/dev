INPUT==1{
    if ($0 == "") next
    _item_arrl = json_split2tokenarr( _item_arr, $0 )
    for (_i=1; _i<=_item_arrl; ++_i) {
        if ( jiter_regexarr_parse( obj, _item_arr[_i], patarrl, patarr ) == false )    continue
        for (i=1; i<=argvl; ++i) {
            if ( obj[ argv[i] ] != "" ) {
                handle_output( i, jstr1(obj, argv[i]) )
            }
        }
        delete obj
    }
}
