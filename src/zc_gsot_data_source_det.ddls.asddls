@EndUserText.label: 'GSOT Data Source Details'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity zc_gsot_data_source_det
  as projection on zi_gsot_data_source_det
{
  key Uuid,
      DsrcUuid,
      SourceTable,
      SourceField,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _DataSource : redirected to parent zc_gsot_data_source
}
