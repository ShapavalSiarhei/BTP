CLASS lhc_DataSource DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR DataSource RESULT result.

    METHODS checkSource FOR VALIDATE ON SAVE                 IMPORTING keys FOR datasource~checkSource.
    METHODS checkmandatory FOR VALIDATE ON SAVE              IMPORTING keys FOR datasource~checkmandatory.
    METHODS setsourcetype FOR DETERMINE ON MODIFY               IMPORTING keys FOR datasource~setsourcetype.
    METHODS checkalternativekey FOR VALIDATE ON SAVE         IMPORTING keys FOR datasource~checkalternativekey.

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

    LOOP AT data_sources INTO DATA(data_source).
      IF data_source-SourceSystem IS NOT INITIAL.
        SELECT SINGLE FROM zi_gsot_src_system_vh
          FIELDS SystemID
          WHERE SystemID = @data_source-SourceSystem
        INTO @DATA(system_exists).
        IF system_exists IS INITIAL.
          APPEND VALUE #( uuid = data_source-Uuid ) TO failed-datasource.
          APPEND VALUE #( uuid                  = data_source-Uuid
                          %msg                  = new_message( id       = gsot_messages
                                                               number   = 003
                                                               v1       = data_source-SourceSystem
                                                               severity = if_abap_behv_message=>severity-error )
                          %element-SourceSystem = if_abap_behv=>mk-on ) TO reported-datasource.
        ENDIF.
      ENDIF.
      IF data_source-IfaceObject IS NOT INITIAL.
        SELECT SINGLE FROM zi_gsot_system_vh
        FIELDS Value
        WHERE Value = @data_source-IfaceObject
      INTO @DATA(syst_type_exists).
        IF syst_type_exists IS INITIAL.
          APPEND VALUE #( uuid = data_source-Uuid ) TO failed-datasource.
          APPEND VALUE #( uuid                 = data_source-Uuid
                          %msg                 = new_message( id       = gsot_messages
                                                              number   = 001
                                                              v1       = data_source-IfaceObject
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
                                                                      SourceSystem = if_abap_behv=>mk-on ) ) )
         RESULT DATA(data_sources).

    LOOP AT data_sources INTO DATA(data_source).
      IF data_source-SourceSystem IS INITIAL.
        APPEND VALUE #( uuid = data_source-Uuid ) TO failed-datasource.
        APPEND VALUE #( uuid                  = data_source-Uuid
                        %msg                  = new_message( id       = gsot_messages
                                                             number   = 002
                                                             severity = if_abap_behv_message=>severity-error )
                        %element-SourceSystem = if_abap_behv=>mk-on ) TO reported-datasource.
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
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD checkAlternativeKey.
    READ ENTITY IN LOCAL MODE zi_gsot_data_source FROM VALUE #( FOR <key> IN keys
                                                                ( %key-Uuid = <key>-Uuid
                                                                  %control  = VALUE #(
                                                                      SourceSystem = if_abap_behv=>mk-on
                                                                      IfaceObject  = if_abap_behv=>mk-on ) ) )
         RESULT DATA(data_sources).
    LOOP AT data_sources INTO DATA(data_source).
      SELECT SINGLE FROM zb_gsot_data_source
       FIELDS uuid
       WHERE sourcesystem = @data_source-SourceSystem
         AND ifaceobject  = @data_source-IfaceObject
      INTO @DATA(exist).
      IF exist IS INITIAL.
        CONTINUE.
      ENDIF.
      APPEND VALUE #( uuid = data_source-Uuid ) TO failed-datasource.
      APPEND VALUE #( uuid                  = data_source-Uuid
                      %msg                  = new_message( id       = gsot_messages
                                                           number   = 004
                                                           severity = if_abap_behv_message=>severity-error )
                      %element-SourceSystem = if_abap_behv=>mk-on  ) TO reported-datasource.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
