@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Source System VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_GSOT_SRC_SYSTEM_VH
  as select from ZI_GSOT_DOMAIN_LOW( p_domain: 'ZD_GSOT_SYSTEM')

{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['SystemName']
  key Value       as SystemID,
      @Semantics.text: true
      Description as SystemName
}
