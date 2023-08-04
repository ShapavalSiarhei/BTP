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

    DATA(key1) = cl_system_uuid=>create_uuid_x16_static( ).
    DATA(key2) = cl_system_uuid=>create_uuid_x16_static( ).
    sources = VALUE #( dev_object      = 'TABLE'
                       link            = 'https://sap.com'
                       created_by      = sy-uname
                       created_at      = '20230813111129.2391370'
                       last_changed_by = sy-uname
                       last_changed_at = '20230813111129.2391370'
                       ( uuid          = key1
                         source_system = 'DS1'
                         iface_object  = 'Standard' )
                       ( uuid          = key2
                         source_system = 'BTP'
                         iface_object  = 'Custom' ) ).

    source_details = VALUE #( created_by      = sy-uname
                              created_at      = '20230813111129.2391370'
                              last_changed_by = sy-uname
                              last_changed_at = '20230813111129.2391370'
                              ( dsrc_uuid    = key1
                                source_table = 'MARA'
                                source_field = 'MTART'
                                uuid         = cl_system_uuid=>create_uuid_x16_static( ) )
                              ( dsrc_uuid    = key1
                                source_table = 'MARA'
                                source_field = 'MATNR'
                                uuid         = cl_system_uuid=>create_uuid_x16_static( ) )
                              ( dsrc_uuid    = key2
                                source_table = 'ZDB_GSOT_DATASRC'
                                source_field = 'DEV_OBJECT'
                                uuid         = cl_system_uuid=>create_uuid_x16_static( ) )
                              ( dsrc_uuid    = key2
                                source_table = 'ZDB_GSOT_DATASRC'
                                source_field = 'SOURCE_SYSTEM'
                                uuid         = cl_system_uuid=>create_uuid_x16_static( ) ) ).

    DELETE FROM zdb_gsot_datasrc.
    DELETE FROM zdb_gsot_dsrcdet.
    INSERT zdb_gsot_datasrc FROM TABLE @sources.
    INSERT zdb_gsot_dsrcdet FROM TABLE @source_details.

    out->write( |Data created successfully!| ).
  ENDMETHOD.
ENDCLASS.
