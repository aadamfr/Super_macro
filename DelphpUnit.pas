{----------------------------------------------------------------}
{ DELPHP - Sub0 - Developpez.com - 23/09/06                      }
{----------------------------------------------------------------}
{                                                                }
{ Interaction entre Delphi et PHP / MySQL                        }
{ Class pour effectuer des requêtes http (post)                  }
{ • Ajoût des sessions pour l'identification                     }
{ • Ajoût des chaines délimiteurs des données                    }
{ • Ajoût téléchargement de données binaires                     }
{                                                                }
{----------------------------------------------------------------}
Unit DelphpUnit;
Interface
Uses Windows, SysUtils, Forms, Classes, HttpProt, mmSystem, Math;

Type
  THttpPost = Class(THttpCli)
    Private
      IsBinaryData: Boolean;
      StartTime: Integer;
      Procedure DocDataProc(Sender: TObject; Buffer: Pointer; Len: Integer);
      Procedure RequestDoneProc(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
      Procedure CookieProc(Sender: TObject; Const Data: String; Var Accept: Boolean);
    Public
      ChampsSaisie: TStrings;
      Completed: Boolean;
      MaxTimeOut: Integer;
      CurTimeOut: Integer;
      StringError: String;
      StringResult: String;
      Constructor Create(AOwner: TComponent); Override;
      Destructor Destroy; Override;
      Procedure ResetPost;
      Procedure AddPost(PostName, PostValue: String);
      Procedure StartPost(BinaryData: Boolean = False);
      Procedure StopPost;
      Function IsCompleted: Boolean;
  End;

  Procedure StrExplode(Const s, sep: String; list: TStrings);
  Function StripHtmlTags(Const sin: String): String;
  Function AddSlashes(Const st: String): String;
  Function MyUrlEncode(Const st: String): String;
  Function MyUrlDecode(Const st: String): String;
  Function SizeToStr(Const Size: Int64): String;


{----------------------------------------------------------------}
{                                                                }
{                       }IMPLEMENTATION{                         }
{                                                                }
{----------------------------------------------------------------}
{$X+,J+}
{$WARNINGS OFF}
{$HINTS OFF}


Const DelimitData = '·¤·';       { Délimiteur des données reçues }


{----------------------------------------------------------------}
{ CONVERSION D'UNE CHAINE EN LISTE DE CHAINE                     }
{----------------------------------------------------------------}
Procedure StrExplode(Const s, sep: String; list: TStrings);
Var x, l: Integer;
    st: String;
Begin
  l := Length(s);
  If (l <= 0) Then Exit;
  x := 1;
  st := '';
  Repeat
    If (s[x] = sep) Then Begin
      list.Add(st);
      st := '';
    End Else st := st + s[x];
    inc(x);
  Until (x > l);
  If (st <> '') Then list.Add(st);
End;


{----------------------------------------------------------------}
{ RETIRE LES BALISES HTML DU TEXTE                               }
{----------------------------------------------------------------}
Function StripHtmlTags(Const sin: String): String;
Var
  x: Integer;
  istag: Boolean;
  newst, curtag: String;
Begin
  Result := sin;
  istag := False;
  curtag := '';
  Try
    For x := 1 To Length(sin) Do Begin
      If (sin[x] = '<') And (istag = false) Then istag := true Else
      If (sin[x] = '>') And (istag = true) Then Begin
        istag := false;
        If (curtag = 'BR') Or (curtag = 'BR/') Or (curtag = 'BR /') Then
          newst := newst + #13#10;
        curtag := '';
      End Else
        If (istag = false) Then newst := newst + sin[x]
        Else curtag := curtag + UpperCase(sin[x]);
    End;
    Result := newst;
  Except End;
End;


{----------------------------------------------------------------}
{ ECHAPPEMENT DES CARACTERES SPECIAUX                            }
{----------------------------------------------------------------}
Function AddSlashes(Const st: String): String;
Var x: Integer;
    f: Set Of Char;
Begin
  f := ['/', '\', ''''];
  Result := '';
  If (st = '') Then Exit;
  For x := 1 To Length(st) Do Begin
    If (st[x] In f) Then Result := Result + '\';
    Result := Result + st[x];
  End;
End;


{----------------------------------------------------------------}
{ CONVERSION STRING -> CODE HEXADECIMAL                          }
{----------------------------------------------------------------}
Function MyUrlEncode(Const st: String): String;
Var x: Integer;
Begin
  Result := '';
  If (st = '') Then Exit;
  For x := 1 To Length(st) Do
    Result := Result + IntToHex(Ord(st[x]), 2);
End;


{----------------------------------------------------------------}
{ CONVERSION CODE HEXADECIMAL -> STRING                          }
{----------------------------------------------------------------}
Function MyUrlDecode(Const st: String): String;
Var x: Integer;
Begin
  Result := '';
  If (Length(st) < 2) Then Exit;
  x := 1;
  Repeat
    Result := Result + Chr(Byte(StrToInt('$' + st[x] + st[x + 1])));
    x := x + 2;
  Until (x >= Length(st));
End;


{----------------------------------------------------------------}
{ CONVERSION D'UNE TAILLE EN CHAINE                              }
{----------------------------------------------------------------}
Function SizeToStr(Const Size: Int64): String;
Begin
  If (Size < $400) Then
    Result := Format(' %d octets ', [Size]) Else
  If (Size < $100000) Then
    Result := Format(' %.1f Ko     ', [Size / $400]) Else
  If (Size < $40000000) Then
    Result := Format(' %.1f Mo     ', [Size / $100000]) Else
  If (Size < $10000000000) Then
    Result := Format(' %.2f Go     ', [Size / $40000000]) Else
    Result := Format(' %.2f To     ', [Size / $10000000000])
End;


{----------------------------------------------------------------}
{ CREATION DE L'OBJET                                            }
{----------------------------------------------------------------}
Constructor THttpPost.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  ProxyPort := '80';
  OnDocData := DocDataProc;
  OnRequestDone := RequestDoneProc;
  Oncookie := CookieProc;
  MaxTimeOut := 30000;
  StartTime := TimeGetTime;
  StringError := '';
  StringResult := '';
  Cookie := '';
  ChampsSaisie := TStringList.Create;
  Completed := True;
End;


{----------------------------------------------------------------}
{ DESTRUCTION DE L'OBJET                                         }
{----------------------------------------------------------------}
Destructor THttpPost.Destroy;
Begin
  OnSendData := Nil;
  SendStream := Nil;
  RcvdStream := Nil;
  ChampsSaisie.Free;
  ChampsSaisie := Nil;
  Inherited Destroy;
End;


{----------------------------------------------------------------}
{ REINITIALISATION DES CHAMPS DE SAISIE                          }
{----------------------------------------------------------------}
Procedure THttpPost.ResetPost;
Begin
  ChampsSaisie.Clear;
  StringError := '';
End;


{----------------------------------------------------------------}
{ AJOUT D'UN CHAMPS DE SAISIE A POSTER                           }
{----------------------------------------------------------------}
Procedure THttpPost.AddPost(PostName, PostValue: String);
Begin
  If (Trim(PostName) <> '') Then
    ChampsSaisie.Add(Trim(PostName) + '=' + MyUrlEncode(Trim(PostValue)));
End;


{----------------------------------------------------------------}
{ POSTER LA REQUETE                                              }
{----------------------------------------------------------------}
Procedure THttpPost.StartPost(BinaryData: Boolean = False);
Var st: String;
    x: Integer;
Begin

  { Préparation de la requête }
  st := '';
  If (ChampsSaisie.Count > 0) Then
    For x := 0 To ChampsSaisie.Count - 1 Do Begin
      If (st <> '') Then st := st + '&';
      st := st + ChampsSaisie.Strings[x];
    End;

  SendStream := Nil;
  SendStream := TMemoryStream.Create;
  x := Length(st);
  Try
    SendStream.Write(st[1], x);
  Except End;
  If (SendStream.Size < x) Or (x >= 8000000) Then Begin
    StringError := 'Erreur : Requête trop longue (8Mo max).';
    Exit;
  End;
  SendStream.Position := 0;

  { Réinitialisation du MaxTimeOut }
  StartTime := TimeGetTime;
  StringError := '';
  StringResult := '';
  Completed := False;

  { Lancement de la requête }
  RcvdStream := Nil;
  RcvdStream := TMemoryStream.Create;
  IsBinaryData := BinaryData;
  PostAsync;
End;


{----------------------------------------------------------------}
{ RECEPTION DU COOKIE / SESSIONS                                 }
{----------------------------------------------------------------}
Procedure THttpPost.CookieProc(Sender: TObject; Const Data: String; Var Accept: Boolean);
Begin
  Cookie := Data;
End;


{----------------------------------------------------------------}
{ RECEPTION DE DONNEES                                           }
{----------------------------------------------------------------}
Procedure THttpPost.DocDataProc(Sender: TObject; Buffer: Pointer; Len: Integer);
Begin
  If (Len <= 0) Then Exit;
  StartTime := TimeGetTime;
End;


{----------------------------------------------------------------}
{ RECEPTION TERMINEE -> ANALYSE DU RESULTAT                      }
{----------------------------------------------------------------}
Procedure THttpPost.RequestDoneProc(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
Var p, l: Integer;
Begin
  Completed := True;
  l := RcvdStream.Size;

  { Test de la connection au serveur }
  If (StatusCode = 404) And (StringError = '') Then
    StringError := 'Serveur introuvable :'#13 + Url Else
  If (StatusCode >= 400) Then StringError := 'Requête abandonnée.' Else
  If (l <= 0) Then Begin
    StringError := 'Aucune donnée réceptionnée.';
    Exit;
  End;

  If (StringError = '') Then Begin

    { Extraction des données délimitées }
    SetLength(StringResult, l);
    RcvdStream.Seek(0, 0);
    RcvdStream.Read(StringResult[1], l);
    p := Pos(DelimitData, StringResult);
    If (p > 0) Then Begin
      p := p + Length(DelimitData);
      StringResult := Copy(StringResult, p, l - p + 1);
      p := Pos(DelimitData, StringResult);
      If (p > 0) Then
        StringResult := Copy(StringResult, 1, p - 1);
    End;

    { Suppression du code HTML dans les données texte }
    If (IsBinaryData = False) Then
      StringResult := StripHtmlTags(StringResult);

    { Récupération du message final }
    l := Length(StringResult);
    If (l > 1) And
       (StringResult[1] = #149) And
       (StringResult[2] = #32) Then
      StringResult := Copy(StringResult, 3, l - 2) Else Begin
      If (IsBinaryData) Then
        StringResult := StripHtmlTags(StringResult);
      StringError := StringResult;
    End;

    { Données binaire dans le flux }
    If (IsBinaryData) And (StringError = '') Then Begin
      RcvdStream := Nil;
      RcvdStream := TMemoryStream.Create;
      RcvdStream.Write(StringResult[1], Length(StringResult) - 6);
      RcvdStream.Seek(0, 0);
    End;
  End;
End;


{----------------------------------------------------------------}
{ TEST LA FIN DE RECEPTION EN CAS D'ERREUR, ABANDON OU TIMEOUT   }
{----------------------------------------------------------------}
Function THttpPost.IsCompleted: Boolean;
Begin
  If (MaxTimeOut > 0) Then
    CurTimeOut := Integer(TimeGetTime) - StartTime Else
    CurTimeOut := MaxTimeOut;
  If (CurTimeOut >= MaxTimeOut) Then StringError := 'TimeOut.';
  Result := (Completed) Or (StringError <> '');
End;


{----------------------------------------------------------------}
{ ABANDON DE LA REQUETE PAR L'UTILISATEUR                        }
{----------------------------------------------------------------}
Procedure THttpPost.StopPost;
Begin
  If (Completed = False) Then StringError := 'Requête abandonnée.';
  SendMessage(0, WM_HTTP_REQUEST_DONE, 0, 0);
  Abort;
  Completed := True;
End;


{----------------------------------------------------------------}
End.
