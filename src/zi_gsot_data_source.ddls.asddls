@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSOT Data Source'
define root view entity zi_gsot_data_source
  as select from zb_gsot_data_source as DataSource
  composition [0..*] of zi_gsot_data_source_det as _DataSourceDetails
  association [1] to ZI_GSOT_SYSTEM_VH          as _SystemTypeTxt   on $projection.IfaceObject = _SystemTypeTxt.Value
  association [1] to ZI_GSOT_SRC_SYSTEM_VH      as _SourceSystemTxt on $projection.SourceSystem = _SourceSystemTxt.SystemID
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

      _DataSourceDetails,
      _SystemTypeTxt,
      _SourceSystemTxt
}
