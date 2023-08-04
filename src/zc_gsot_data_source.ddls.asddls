@EndUserText.label: 'GSOT Data Source'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zc_gsot_data_source
  as projection on zi_gsot_data_source
{
  key Uuid,
      SourceSystem,
      IfaceObject,
      DevObject,
      Link,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _DataSourceDetails : redirected to composition child zc_gsot_data_source_det
}
