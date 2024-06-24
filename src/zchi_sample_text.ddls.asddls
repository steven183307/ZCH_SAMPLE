@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sample text'
define root  view entity zchi_sample_text
  as select from zch_sample_text
//  association to parent zchi_sd_sample as _sample on $projection.salesdocument = _sample.SalesDocument
//  association [0..1] to zchi_sd_sample  as _sample on  $projection.salesdocument = _sample.SalesDocument
 
{
  key ruuid,
  key salesdocument,
      longstring,
      locallastchangedat as Locallastchangedat
//       _sample
}
