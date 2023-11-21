import 'package:flutter/foundation.dart';

const kAppName = 'CSX Delivery';
final kPadding = 16.0;
final kPaddingInternal = 8.0;
const kMaxWidthBodyPage = 800.0;
const kApiUrlBase = String.fromEnvironment('API_URL_BASE',
    defaultValue:
        'https://api-delivery-dev.csxinovacao.com.br/api-portal-estabelecimento');
const kGoogleApiKey = String.fromEnvironment('GOOGLE_API_KEY',
    defaultValue: kDebugMode
        ? 'AIzaSyDLLjWUNDT3Dpje9QWkAjp8pYuKw9RIFew'
        : 'AIzaSyAsqMmDnlNmR87D5tzBUgRQlVclinkUF8I');