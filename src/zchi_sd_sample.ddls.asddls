@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Document(Header)'
define root view entity zchi_sd_sample
  as select from zch_sd_sample

{
  key ruuid                as ruuid,
  key salesdocument        as salesdocument,
      salesgroup           as salesgroup,
      salesdocumentitem    as salesdocumentitem,
      material             as material,
      salesdocumentdate    as salesdocumentdate,
      salesorganization    as salesorganization,
      distributionchannel  as distributionchannel,
      organizationdivision as organizationdivision,
      transactioncurrency  as transactioncurrency,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat   as locallastchangedat,
      @Semantics.user.createdBy: true
      created_by           as created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at           as created_at,
      @Semantics.user.lastChangedBy: true
      lastchangedby        as lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat        as lastchangedat


}
