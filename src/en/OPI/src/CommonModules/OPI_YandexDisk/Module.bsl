﻿// OS Location: ./OInt/core/Modules/OPI_YandexDisk.os
// Library: Yandex Disk
// CLI command: yadisk

// MIT License

// Copyright (c) 2023 Anton Tsitavets

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// https://github.com/Bayselonarrend/OpenIntegrations

// BSLLS:LatinAndCyrillicSymbolInWord-off
// BSLLS:IncorrectLineBreak-off
// BSLLS:NumberOfOptionalParams-off
// BSLLS:UsingServiceTag-off

//@skip-check method-too-many-params

// Uncomment if OneScript is executed
// #Use "../../tools"

#Region ProgrammingInterface

#Region FileAndFolderManagement

// Get disk information
// Gets information about the current disk
//
// Parameters:
// Token - String - Token - token
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetDiskInformation(Val Token) Export

OPI_TypeConversion.GetLine(Token);

Headers = AuthorizationHeader(Token);
Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk", , Headers);

Return Response;

EndFunction

// Create folder
// Creates a directory on the disk
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to the created folder - path
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function CreateFolder(Val Token, Val Path) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);

Headers = AuthorizationHeader(Token);
URL = "https://cloud-api.yandex.net/v1/disk/resources";
Href = "href";

Parameters = New Structure;
Parameters.Insert("path", Path);

Parameters = OPI_Tools.RequestParametersToString(Parameters);
Response = OPI_Tools.Put(URL + Parameters, , Headers, False);

ResponseURL = Response[Href];

If Not ValueIsFilled(ResponseURL) Then
Return Response;
EndIf;

Response = OPI_Tools.Get(ResponseURL, , Headers);

Return Response;

EndFunction

// Get object
// Gets information about a disk object at the specified path
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to folder or file - path
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetObject(Val Token, Val Path) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);

Headers = AuthorizationHeader(Token);
Parameters = New Structure;
Parameters.Insert("path", Path);

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/resources", Parameters, Headers);

Return Response;

EndFunction

// Delete object
// Deletes an object at the specified path
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to the folder or file to be deleted - path
// ToCart - Boolean - To cart - can
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function DeleteObject(Val Token, Val Path, Val ToCart = True) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);
OPI_TypeConversion.GetBoolean(ToCart);

Headers = AuthorizationHeader(Token);

Parameters = New Structure;
Parameters.Insert("path" , Path);
Parameters.Insert("permanently", Not ToCart);

Response = OPI_Tools.Delete("https://cloud-api.yandex.net/v1/disk/resources", Parameters, Headers);

Return Response;

EndFunction

// Create object copy
// Creates a copy of the object at the specified path and path to the original
//
// Parameters:
// Token - String - Token - token
// Original - String - Path to the original file or directory - from
// Path - String - Destination path for the copy - to
// Overwrite - Boolean - Overwrite if a file with the same name already exists - rewrite
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function CreateObjectCopy(Val Token, Val Original, Val Path, Val Overwrite = False) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Original);
OPI_TypeConversion.GetLine(Path);
OPI_TypeConversion.GetBoolean(Overwrite);

Headers = AuthorizationHeader(Token);
URL = "https://cloud-api.yandex.net/v1/disk/resources/copy";
Href = "href";

Parameters = New Structure;
Parameters.Insert("from" , Original);
Parameters.Insert("path" , Path);
Parameters.Insert("overwrite" , Overwrite);

Parameters = OPI_Tools.RequestParametersToString(Parameters);
Response = OPI_Tools.Post(URL + Parameters, , Headers, False);

ResponseURL = Response[Href];

If Not ValueIsFilled(ResponseURL) Then
Return Response;
EndIf;

Response = OPI_Tools.Get(ResponseURL, , Headers);

Return Response;

EndFunction

// Get download link
// Gets a download link for the file
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to the file for downloading - path
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetDownloadLink(Val Token, Val Path) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);

Headers = AuthorizationHeader(Token);

Parameters = New Structure;
Parameters.Insert("path", Path);

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/resources/download", Parameters, Headers);

Return Response;

EndFunction

// Download file
// Downloads a file at the specified path
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to the file for downloading - path
// SavePath - String - File save path - out
//
// Return value:
// BinaryData,String - Binary data or file path when SavePath parameter is specified
Function DownloadFile(Val Token, Val Path, Val SavePath = "") Export

OPI_TypeConversion.GetLine(SavePath);
Response = GetDownloadLink(Token, Path);
URL = Response["href"];

If Not ValueIsFilled(URL) Then
Return Response;
EndIf;

Response = OPI_Tools.Get(URL, , , SavePath);

Return Response;

EndFunction

// Get list of files
// Gets a list of files with or without filtering by type
// List available typeоin: audio, backup, book, compressed, data, development,
// diskimage, document, encoded, executable, flash, font,
// mage, settings, spreadsheet, text, unknown, video, web
//
// Parameters:
// Token - String - Token - token
// Quantity - Number, String - Number of returned objects - amount
// OffsetFromStart - Number - Offset for getting objects not from the beginning of the list - offset
// FilterByType - String - Filter by file type - type
// SortByDate - Boolean - True > sort by date, False > alphabetically - datesort
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetFilesList(Val Token
, Val Quantity = 0
, Val OffsetFromStart = 0
, Val FilterByType = ""
, Val SortByDate = False) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Quantity);
OPI_TypeConversion.GetLine(OffsetFromStart);
OPI_TypeConversion.GetLine(FilterByType);
OPI_TypeConversion.GetBoolean(SortByDate);

Headers = AuthorizationHeader(Token);

Parameters = New Structure;

If ValueIsFilled(Quantity) Then
Parameters.Insert("limit", OPI_Tools.NumberToString(Quantity));
EndIf;

If ValueIsFilled(OffsetFromStart) Then
Parameters.Insert("offset", OPI_Tools.NumberToString(OffsetFromStart));
EndIf;

If ValueIsFilled(FilterByType) Then
Parameters.Insert("media_type", FilterByType);
EndIf;

If SortByDate Then
Destination = "last-uploaded";
Else
Destination = "files";
EndIf;

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/resources/" + Destination, Parameters, Headers);

Return Response;

EndFunction

// Move object
// Moves the object to the specified path and path to the original
//
// Parameters:
// Token - String - Token - token
// Original - String - Path to the original file or folder - from
// Path - String - Destination path for moving - to
// Overwrite - Boolean - Overwrite if a file with the same name already exists - rewrite
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function MoveObject(Val Token, Val Original, Val Path, Val Overwrite = False) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Original);
OPI_TypeConversion.GetLine(Path);
OPI_TypeConversion.GetBoolean(Overwrite);

Headers = AuthorizationHeader(Token);
URL = "https://cloud-api.yandex.net/v1/disk/resources/move";
Href = "href";

Parameters = New Structure;
Parameters.Insert("from" , Original);
Parameters.Insert("path" , Path);
Parameters.Insert("overwrite" , Overwrite);

Parameters = OPI_Tools.RequestParametersToString(Parameters);
Response = OPI_Tools.Post(URL + Parameters, , Headers, False);
ResponseURL = Response[Href];

If Not ValueIsFilled(ResponseURL) Then
Return Response;
EndIf;

Response = OPI_Tools.Get(ResponseURL, , Headers);

Return Response;

EndFunction

// Upload file
// Uploads a file to disk at the specified path
//
// Parameters:
// Token - String - Token - token
// Path - String - Path for saving the file to disk - path
// File - String, BinaryData - File for upload - file
// Overwrite - Boolean - Overwrite if a file with the same name already exists - rewrite
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function UploadFile(Val Token, Val Path, Val File, Val Overwrite = False) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);
OPI_TypeConversion.GetBoolean(Overwrite);
OPI_TypeConversion.GetBinaryData(File);

Headers = AuthorizationHeader(Token);
Href = "href";
File = New Structure("file", File);

Parameters = New Structure;
Parameters.Insert("path" , Path);
Parameters.Insert("overwrite" , Overwrite);

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/resources/upload", Parameters, Headers);
URL = Response[Href];

If Not ValueIsFilled(URL) Then
Return Response;
EndIf;

Response = OPI_Tools.PutMultipart(URL, New Structure(), File, "multipart", Headers);

Return Response;

EndFunction

// Upload file by URL
// Downloads a file to disk from the specified URL
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to place the downloaded file - path
// Address - String - File URL - url
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function UploadFileByURL(Val Token, Val Path, Val Address) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);
OPI_TypeConversion.GetLine(Address);

Headers = AuthorizationHeader(Token);
URL = "https://cloud-api.yandex.net/v1/disk/resources/upload";

Parameters = New Structure;
Parameters.Insert("url" , EncodeString(Address, StringEncodingMethod.URLInURLEncoding));
Parameters.Insert("path", Path);

Parameters = OPI_Tools.RequestParametersToString(Parameters);
Response = OPI_Tools.Post(URL + Parameters, , Headers, False);

Return Response;

EndFunction

#EndRegion

#Region ManagePublicAccess

// Publish object
// Publishes the disk object for public access
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to the object to be published - path
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function PublishObject(Val Token, Val Path) Export
Return TogglePublicAccess(Token, Path, True);
EndFunction

// Unpublish object
// Unpublishes a previously published object
//
// Parameters:
// Token - String - Token - token
// Path - String - Path to the previously published object - path
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function CancelObjectPublication(Val Token, Val Path) Export
Return TogglePublicAccess(Token, Path, False);
EndFunction

// Get published list объеtoтоin.
// Gets a list of published objects
//
// Parameters:
// Token - String - Token - token
// Quantity - Number - Number of returned objects - amount
// OffsetFromStart - Number - Offset for getting objects not from the beginning of the list - offset
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetPublishedObjectsList(Val Token, Val Quantity = 0, Val OffsetFromStart = 0) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Quantity);
OPI_TypeConversion.GetLine(OffsetFromStart);

Headers = AuthorizationHeader(Token);

Parameters = New Structure;

If ValueIsFilled(Quantity) Then
Parameters.Insert("limit", Quantity);
EndIf;

If ValueIsFilled(OffsetFromStart) Then
Parameters.Insert("offset", OffsetFromStart);
EndIf;

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/resources/public", Parameters, Headers);

Return Response;

EndFunction

// Get public object
// Gets information about the published object by its URL
//
// Parameters:
// Token - String - Token - token
// URL - String - Object address - url
// Quantity - Number - Quantity inозinращаемых inложенных объеtoтоin (for directory) - amount
// OffsetFromStart - Number - Offset for getting nested objects not from the beginning of the list - offset
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetPublicObject(Val Token, Val URL, Val Quantity = 0, Val OffsetFromStart = 0) Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(URL);
OPI_TypeConversion.GetLine(Quantity);
OPI_TypeConversion.GetLine(OffsetFromStart);

Headers = AuthorizationHeader(Token);

Parameters = New Structure;

If ValueIsFilled(Quantity) Then
Parameters.Insert("limit", OPI_Tools.NumberToString(Quantity));
EndIf;

If ValueIsFilled(OffsetFromStart) Then
Parameters.Insert("offset", OPI_Tools.NumberToString(OffsetFromStart));
EndIf;

Parameters.Insert("public_key", URL);

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/public/resources", Parameters, Headers);

Return Response;

EndFunction

// Get download link for public object
// Gets a direct link to download the public object
//
// Parameters:
// Token - String - Token - token
// URL - String - Object address - url
// Path - String - Path inside the object - path
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function GetDownloadLinkForPublicObject(Val Token, Val URL, Val Path = "") Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(URL);
OPI_TypeConversion.GetLine(Path);

Headers = AuthorizationHeader(Token);

Parameters = New Structure;

If ValueIsFilled(Path) Then
Parameters.Insert("path", Path);
EndIf;

Parameters.Insert("public_key", URL);

Response = OPI_Tools.Get("https://cloud-api.yandex.net/v1/disk/public/resources/download", Parameters, Headers);

Return Response;

EndFunction

// Save public object to disk
// Saves the public object to your disk
//
// Parameters:
// Token - String - Token - token
// URL - String - Object address - url
// From - String - Path inнутри публичного directory (тольtoо for папоto) - from
// To - String - File save path - to
//
// Return value:
// Key-Value Pair - serialized JSON response from Yandex
Function SavePublicObjectToDisk(Val Token, Val URL, From = "", To = "") Export

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(URL);
OPI_TypeConversion.GetLine(From);
OPI_TypeConversion.GetLine(To);

Headers = AuthorizationHeader(Token);
Address = "https://cloud-api.yandex.net/v1/disk/public/resources/save-to-disk";
Href = "href";

Parameters = New Structure;
Parameters.Insert("public_key", URL);

If ValueIsFilled(From) Then
Parameters.Insert("path", From);
EndIf;

If ValueIsFilled(To) Then
Parameters.Insert("save_path", To);
EndIf;

Parameters = OPI_Tools.RequestParametersToString(Parameters);
Response = OPI_Tools.Post(Address + Parameters, , Headers, False);

ResponseURL = Response[Href];

If Not ValueIsFilled(ResponseURL) Then
Return Response;
EndIf;

Response = OPI_Tools.Get(ResponseURL, , Headers);

Return Response;

EndFunction

#EndRegion

#EndRegion

#Region ServiceProceduresAndFunctions

Function AuthorizationHeader(Val Token)

Headers = New Match;
Headers.Insert("Authorization", "OAuth " + Token);

Return Headers;

EndFunction

Function TogglePublicAccess(Val Token, Val Path, Val PublicAccess)

OPI_TypeConversion.GetLine(Token);
OPI_TypeConversion.GetLine(Path);
OPI_TypeConversion.GetBoolean(PublicAccess);

Headers = AuthorizationHeader(Token);
Destination = ?(PublicAccess, "publish", "unpublish");
Href = "href";

URL = "https://cloud-api.yandex.net/v1/disk/resources/" + Destination;

Parameters = New Structure;
Parameters.Insert("path", Path);

Parameters = OPI_Tools.RequestParametersToString(Parameters);
Response = OPI_Tools.Put(URL + Parameters, , Headers, False);

ResponseURL = Response[Href];

If Not ValueIsFilled(ResponseURL) Then
Return Response;
EndIf;

Response = OPI_Tools.Get(ResponseURL, , Headers);

Return Response;

EndFunction

#EndRegion
