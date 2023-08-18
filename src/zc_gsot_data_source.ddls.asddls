@EndUserText.label: 'GSOT Data Source'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['SourceID']
@ObjectModel.representativeKey: 'Uuid'
define root view entity zc_gsot_data_source
  provider contract transactional_query
  as projection on zi_gsot_data_source

{
  key Uuid,
      SourceID,
      @ObjectModel.text.element: ['SystemName']
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_GSOT_SRC_SYSTEM_VH', entity.element: 'SystemID' }]
      SourceSystem,
      @ObjectModel.text.element: ['SystemTypeTxt']
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_GSOT_SYSTEM_VH', entity.element: 'Value' }]
      IfaceObject,
      DevObject,
      Link,
      SourceDescription,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      @Semantics.text: true
      _SystemTypeTxt.Description  as SystemTypeTxt,
      @Semantics.text: true
      _SourceSystemTxt.SystemName as SystemName,
      /* Associations */
      _DataSourceDetails : redirected to composition child zc_gsot_data_source_det


}
