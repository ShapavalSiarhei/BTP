@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSOT Data Source'
define root view entity zi_gsot_data_source
  as select from zb_gsot_data_source as DataSource
  composition [0..*] of zi_gsot_data_source_det as _DataSourceDetails
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

      _DataSourceDetails
}
