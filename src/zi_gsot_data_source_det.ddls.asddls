@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSOT Data Source Details'
define view entity zi_gsot_data_source_det
  as select from zb_gsot_data_source_det as DataSourceDetails
  association to parent zi_gsot_data_source as _DataSource on $projection.DsrcUuid = _DataSource.Uuid
{
  key Uuid,
      DsrcUuid,
      SourceTable,
      SourceField,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      _DataSource
}
