CLASS lsc_zi_gsot_data_source DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

  PRIVATE SECTION.
    CONSTANTS gsot_messages TYPE symsgid VALUE 'ZMC_GSOT_MESSAGES'.

    METHODS is_source_syst_object_dbl IMPORTING source_system TYPE zde_source_syst
                                                source_object TYPE zde_iface_object
                                      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS lsc_zi_gsot_data_source IMPLEMENTATION.
  METHOD save_modified.
    IF update-datasource IS INITIAL.
      RETURN.
    ENDIF.
    LOOP AT update-datasource REFERENCE INTO DATA(data_source).
      IF NOT (    data_source->%control-SourceSystem = if_abap_behv=>mk-on
               OR data_source->%control-IfaceObject  = if_abap_behv=>mk-on ).
        CONTINUE.
      ENDIF.

      IF is_source_syst_object_dbl( source_system = data_source->SourceSystem
                                    source_object = data_source->IfaceObject )
         = abap_false.
        CONTINUE.
      ENDIF.
      reported-datasource = VALUE #( BASE  reported-datasource
                                     uuid = data_source->Uuid
                                     %msg = new_message( id       = gsot_messages
                                                         number   = 004
                                                         severity = if_abap_behv_message=>severity-error )
                                     ( %element-SourceSystem = if_abap_behv=>mk-on  )
                                     ( %element-IfaceObject  = if_abap_behv=>mk-on  ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD is_source_syst_object_dbl.
    SELECT SINGLE FROM zb_gsot_data_source
     FIELDS CASE WHEN uuid IS NOT INITIAL THEN 'X' END
      WHERE sourcesystem = @source_system
        AND ifaceobject  = @source_object
     INTO @result.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_DataSource DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR DataSource RESULT result.

    METHODS checkSource FOR VALIDATE ON SAVE                 IMPORTING keys FOR datasource~checkSource.
    METHODS checkmandatory FOR VALIDATE ON SAVE              IMPORTING keys FOR datasource~checkmandatory.
    METHODS setsourcetype FOR DETERMINE ON MODIFY               IMPORTING keys FOR datasource~setsourcetype.

    METHODS is_source_system_exists IMPORTING source_system TYPE zde_source_syst
                                    RETURNING VALUE(result) TYPE abap_bool.

    METHODS is_source_object_exists IMPORTING source_object TYPE zde_iface_object
                                    RETURNING VALUE(result) TYPE abap_bool.

    CONSTANTS gsot_messages     TYPE symsgid VALUE 'ZMC_GSOT_MESSAGES'.
    CONSTANTS source_type_table TYPE string  VALUE 'TABLE'.

ENDCLASS.

CLASS lhc_DataSource IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD checkSource.
    READ ENTITY IN LOCAL MODE zi_gsot_data_source FROM VALUE #( FOR <key> IN keys
                                                                ( %key-Uuid = <key>-Uuid
                                                                  %control  = VALUE #(
                                                                      IfaceObject  = if_abap_behv=>mk-on
                                                                      SourceSystem = if_abap_behv=>mk-on ) ) )
         RESULT DATA(data_sources).

    LOOP AT data_sources REFERENCE INTO DATA(data_source).
      IF data_source->SourceSystem IS NOT INITIAL.
        IF is_source_system_exists( data_source->SourceSystem ) = abap_false.
          APPEND VALUE #( uuid = data_source->Uuid ) TO failed-datasource.
          APPEND VALUE #( uuid                  = data_source->Uuid
                          %msg                  = new_message( id       = gsot_messages
                                                               number   = 003
                                                               v1       = data_source->SourceSystem
                                                               severity = if_abap_behv_message=>severity-error )
                          %element-SourceSystem = if_abap_behv=>mk-on ) TO reported-datasource.
        ENDIF.
      ENDIF.
      IF data_source->IfaceObject IS NOT INITIAL.
        IF is_source_object_exists( data_source->IfaceObject ) = abap_false.
          APPEND VALUE #( uuid = data_source->Uuid ) TO failed-datasource.
          APPEND VALUE #( uuid                 = data_source->Uuid
                          %msg                 = new_message( id       = gsot_messages
                                                              number   = 001
                                                              v1       = data_source->IfaceObject
                                                              severity = if_abap_behv_message=>severity-error )
                          %element-IfaceObject = if_abap_behv=>mk-on ) TO reported-datasource.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD checkMandatory.
    READ ENTITY IN LOCAL MODE zi_gsot_data_source FROM VALUE #( FOR <key> IN keys
                                                                ( %key-Uuid = <key>-Uuid
                                                                  %control  = VALUE #(
                                                                      SourceSystem = if_abap_behv=>mk-on
                                                                      SourceID     = if_abap_behv=>mk-on ) ) )
         RESULT DATA(data_sources).

    LOOP AT data_sources REFERENCE INTO DATA(data_source).
      IF data_source->SourceSystem IS INITIAL.
        APPEND VALUE #( uuid = data_source->Uuid ) TO failed-datasource.
        APPEND VALUE #( uuid                  = data_source->Uuid
                        %msg                  = new_message( id       = gsot_messages
                                                             number   = 002
                                                             severity = if_abap_behv_message=>severity-error )
                        %element-SourceSystem = if_abap_behv=>mk-on ) TO reported-datasource.
      ENDIF.
      IF data_source->SourceID IS INITIAL.
        APPEND VALUE #( uuid = data_source->Uuid ) TO failed-datasource.
        APPEND VALUE #( uuid              = data_source->Uuid
                        %msg              = new_message( id       = gsot_messages
                                                         number   = 002
                                                         severity = if_abap_behv_message=>severity-error )
                        %element-SourceID = if_abap_behv=>mk-on ) TO reported-datasource.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setSourceType.
    READ ENTITIES OF zi_gsot_data_source IN LOCAL MODE
         ENTITY DataSource
         FIELDS ( DevObject )
         WITH CORRESPONDING #( keys )
         RESULT DATA(data_sources).

    MODIFY ENTITIES OF zi_gsot_data_source IN LOCAL MODE
           ENTITY DataSource
           UPDATE FIELDS ( DevObject )
           WITH VALUE #( FOR data_source IN data_sources ( %key = data_source-%key devobject = source_type_table ) )
           REPORTED FINAL(result).
    reported-datasource = CORRESPONDING #( result-datasource ).
  ENDMETHOD.

  METHOD is_source_object_exists.
    SELECT SINGLE FROM zi_gsot_system_vh
        FIELDS CASE WHEN Value IS NOT INITIAL THEN 'X' END
        WHERE Value = @source_object
        INTO @result.
  ENDMETHOD.

  METHOD is_source_system_exists.
    SELECT SINGLE FROM zi_gsot_src_system_vh
    FIELDS CASE WHEN SystemID IS NOT INITIAL THEN 'X' END
          WHERE SystemID = @source_system
        INTO @result.
  ENDMETHOD.
ENDCLASS.
