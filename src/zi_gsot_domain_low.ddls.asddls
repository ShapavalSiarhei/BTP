@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Values'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_GSOT_DOMAIN_LOW
  with parameters
    p_domain : sxco_ad_object_name
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : $parameters.p_domain)   as Domain
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : $parameters.p_domain) as DomainText on  Domain.domain_name    = DomainText.domain_name
                                                                                                       and Domain.value_position = DomainText.value_position
                                                                                                       and DomainText.language   = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Domain.value_low as Value,
      @Semantics.text: true
      DomainText.text  as Description
}
