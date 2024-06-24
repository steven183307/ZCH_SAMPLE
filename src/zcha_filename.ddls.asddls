@EndUserText.label: 'file name'
@Metadata.allowExtensions: true
define abstract entity zcha_filename
//  with parameters parameter_name : parameter_type
{
    filename           : abap.char(128);
    
    typeName            : abap.char(10) ;
}
