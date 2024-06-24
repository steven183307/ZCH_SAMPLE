@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sample text'
define root view entity zchc_sample_text
    provider contract transactional_query
    as projection on zchi_sample_text
//   association [0..1] to zchi_sd_sample  as _sample on  $projection.salesdocument = _sample.SalesDocument
//  
{
    key ruuid,
    key salesdocument,
    longstring
//    _sample : redirected to parent zchc_sd_sample
}
