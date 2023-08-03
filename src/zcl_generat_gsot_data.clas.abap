CLASS zcl_generat_gsot_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_generat_gsot_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA sources        TYPE TABLE OF zdb_gsot_datasrc.
    DATA source_details TYPE TABLE OF zdb_gsot_dsrcdet.

    DATA(s_key) = cl_system_uuid=>create_uuid_x16_static( ).
    sources = VALUE #( ( uuid            = s_key
                         source_system   = 'DS1'
                         iface_object    = 'Standard'
                         dev_object      = 'TABLE'
                         link            = 'https://sap.com'
                         created_by      = sy-uname
                         created_at      = '20230813111129.2391370'
                         last_changed_by = sy-uname
                         last_changed_at = '20230813111129.2391370' ) ).

    source_details = VALUE #( dsrc_uuid       = s_key
                              source_table    = 'MARA'
                              created_by      = sy-uname
                              created_at      = '20230813111129.2391370'
                              last_changed_by = sy-uname
                              last_changed_at = '20230813111129.2391370'
                              ( uuid         = cl_system_uuid=>create_uuid_x16_static( )
                                source_field = 'MATNR' )
                              ( uuid         = cl_system_uuid=>create_uuid_x16_static( )
                                source_field = 'MTART' )   ).

    DELETE FROM zdb_gsot_datasrc.
    DELETE FROM zdb_gsot_dsrcdet.
    INSERT zdb_gsot_datasrc FROM TABLE @sources.
    INSERT zdb_gsot_dsrcdet FROM TABLE @source_details.

    out->write( |Data created successfully!| ).
  ENDMETHOD.
ENDCLASS.