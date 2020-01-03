module Foo.Bar.Auto exposing (..)

import Foo.Bar exposing (..)
import Dict
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Set


-- HARDCODE


encodeString : String -> Json.Encode.Value
encodeString =
    Json.Encode.string


encodeInt : Int -> Json.Encode.Value
encodeInt =
    Json.Encode.int


encodeFloat : Float -> Json.Encode.Value
encodeFloat =
    Json.Encode.float


encodeBool : Bool -> Json.Encode.Value
encodeBool =
    Json.Encode.bool


encodeList : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value
encodeList =
    Json.Encode.list


encodeSet : (comparable -> Json.Encode.Value) -> Set.Set comparable -> Json.Encode.Value
encodeSet encoder =
    Set.toList >> encodeList encoder


encodeDict : (a -> Json.Encode.Value) -> (b -> Json.Encode.Value) -> Dict.Dict a b -> Json.Encode.Value
encodeDict keyEncoder =
    Json.Encode.dict (\k -> Json.Encode.encode 0 (keyEncoder k))


--

decodeString : Json.Decode.Decoder String
decodeString =
    Json.Decode.string


decodeInt : Json.Decode.Decoder Int
decodeInt =
    Json.Decode.int


decodeFloat : Json.Decode.Decoder Float
decodeFloat =
    Json.Decode.float


decodeBool : Json.Decode.Decoder Bool
decodeBool =
    Json.Decode.bool


decodeList : (Json.Decode.Decoder a) -> Json.Decode.Decoder (List a)
decodeList =
    Json.Decode.list


decodeSet : (Json.Decode.Decoder comparable) -> Json.Decode.Decoder (Set.Set comparable)
decodeSet =
    Json.Decode.list >> Json.Decode.map Set.fromList


decodeDict : (Json.Decode.Decoder comparable) -> (Json.Decode.Decoder b) -> Json.Decode.Decoder (Dict.Dict comparable b)
decodeDict keyDecoder valueDecoder =
    Json.Decode.dict valueDecoder
        |> Json.Decode.map (\dict ->
            Dict.foldl (\string v acc ->
                case Json.Decode.decodeString keyDecoder string of
                    Ok k ->
                        Dict.insert k v acc
                    Err _ ->
                        acc
            ) Dict.empty dict
        )

-- PRELUDE


{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
encodeMaybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
encodeMaybe funcArga value =
    case value of
        (Nothing) -> (Json.Encode.list identity [ encodeString "Nothing" ])
        (Just m0) -> (Json.Encode.list identity [ encodeString "Just", (funcArga m0) ])



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
encodeResult : (x -> Json.Encode.Value) -> (a -> Json.Encode.Value) -> Result x a -> Json.Encode.Value
encodeResult funcArgx funcArga value =
    case value of
        (Err m0) -> (Json.Encode.list identity [ encodeString "Err", (funcArgx m0) ])
        (Ok m0) -> (Json.Encode.list identity [ encodeString "Ok", (funcArga m0) ])

{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Nothing") [],CustomTypeConstructor (TitleCaseDotPhrase "Just") [ConstructorTypeParam "a"]], name = TypeName "Maybe" ["a"] } -}
decodeMaybe : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Maybe a)
decodeMaybe funcArga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Nothing" -> (Json.Decode.succeed Nothing)
                    "Just" -> (Json.Decode.succeed Just |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArga))))
                    _ -> Json.Decode.fail ("Unexpected Maybe: " ++ word)
            )
                 



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Err") [ConstructorTypeParam "x"],CustomTypeConstructor (TitleCaseDotPhrase "Ok") [ConstructorTypeParam "a"]], name = TypeName "Result" ["x","a"] } -}
decodeResult : (Json.Decode.Decoder (x)) -> (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Result x a)
decodeResult funcArgx funcArga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Err" -> (Json.Decode.succeed Err |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArgx))))
                    "Ok" -> (Json.Decode.succeed Ok |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArga))))
                    _ -> Json.Decode.fail ("Unexpected Result: " ++ word)
            )
                 




{-| TypeAliasDef (AliasCustomType (TypeName "Choice" []) (CustomTypeConstructor (TitleCaseDotPhrase "Option") [CustomTypeConstructor (TitleCaseDotPhrase "Bool") []])) -}
encodeChoice : Choice -> Json.Encode.Value
encodeChoice value =
    (encodeOption (encodeBool)) value



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Hello") [],CustomTypeConstructor (TitleCaseDotPhrase "Good") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Result") [ConstructorTypeParam "x",CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]]]], name = TypeName "Hello" ["x"] } -}
encodeHello : (x -> Json.Encode.Value) -> Hello x -> Json.Encode.Value
encodeHello funcArgx value =
    case value of
        (Hello) -> (Json.Encode.list identity [ encodeString "Hello" ])
        (Good m0 m1) -> (Json.Encode.list identity [ encodeString "Good", (encodeString m0), (encodeResult (funcArgx) (encodeMaybe (encodeString)) m1) ])



{-| TypeAliasDef (AliasCustomType (TypeName "Lookup" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Int") []])) -}
encodeLookup : Lookup -> Json.Encode.Value
encodeLookup value =
    (encodeDict (encodeString) (encodeInt)) value



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "None") [],CustomTypeConstructor (TitleCaseDotPhrase "Some") [ConstructorTypeParam "a"]], name = TypeName "Option" ["a"] } -}
encodeOption : (a -> Json.Encode.Value) -> Option a -> Json.Encode.Value
encodeOption funcArga value =
    case value of
        (None) -> (Json.Encode.list identity [ encodeString "None" ])
        (Some m0) -> (Json.Encode.list identity [ encodeString "Some", (funcArga m0) ])



{-| TypeAliasDef (AliasRecordType (TypeName "Payload" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "author") (CustomTypeConstructor (TitleCaseDotPhrase "Person") [])]) -}
encodePayload : Payload -> Json.Encode.Value
encodePayload value =
    Json.Encode.object
        [ ("title", (encodeString) value.title)
        , ("author", (encodePerson) value.author)
        ]



{-| TypeAliasDef (AliasRecordType (TypeName "Person" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "age") (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])]) -}
encodePerson : Person -> Json.Encode.Value
encodePerson value =
    Json.Encode.object
        [ ("name", (encodeString) value.name)
        , ("age", (encodeInt) value.age)
        ]

{-| TypeAliasDef (AliasCustomType (TypeName "Choice" []) (CustomTypeConstructor (TitleCaseDotPhrase "Option") [CustomTypeConstructor (TitleCaseDotPhrase "Bool") []])) -}
decodeChoice : Json.Decode.Decoder (Choice)
decodeChoice  =
    (decodeOption (decodeBool))



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "Hello") [],CustomTypeConstructor (TitleCaseDotPhrase "Good") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Result") [ConstructorTypeParam "x",CustomTypeConstructor (TitleCaseDotPhrase "Maybe") [CustomTypeConstructor (TitleCaseDotPhrase "String") []]]]], name = TypeName "Hello" ["x"] } -}
decodeHello : (Json.Decode.Decoder (x)) -> Json.Decode.Decoder (Hello x)
decodeHello funcArgx =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Hello" -> (Json.Decode.succeed Hello)
                    "Good" -> (Json.Decode.succeed Good |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (decodeString))) |> (Json.Decode.Pipeline.custom (Json.Decode.index 2 (decodeResult (funcArgx) (decodeMaybe (decodeString))))))
                    _ -> Json.Decode.fail ("Unexpected Hello: " ++ word)
            )
                 



{-| TypeAliasDef (AliasCustomType (TypeName "Lookup" []) (CustomTypeConstructor (TitleCaseDotPhrase "Dict") [CustomTypeConstructor (TitleCaseDotPhrase "String") [],CustomTypeConstructor (TitleCaseDotPhrase "Int") []])) -}
decodeLookup : Json.Decode.Decoder (Lookup)
decodeLookup  =
    (decodeDict (decodeString) (decodeInt))



{-| CustomTypeDef { constructors = [CustomTypeConstructor (TitleCaseDotPhrase "None") [],CustomTypeConstructor (TitleCaseDotPhrase "Some") [ConstructorTypeParam "a"]], name = TypeName "Option" ["a"] } -}
decodeOption : (Json.Decode.Decoder (a)) -> Json.Decode.Decoder (Option a)
decodeOption funcArga =
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "None" -> (Json.Decode.succeed None)
                    "Some" -> (Json.Decode.succeed Some |> (Json.Decode.Pipeline.custom (Json.Decode.index 1 (funcArga))))
                    _ -> Json.Decode.fail ("Unexpected Option: " ++ word)
            )
                 



{-| TypeAliasDef (AliasRecordType (TypeName "Payload" []) [CustomField (FieldName "title") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "author") (CustomTypeConstructor (TitleCaseDotPhrase "Person") [])]) -}
decodePayload : Json.Decode.Decoder (Payload)
decodePayload  =
    Json.Decode.succeed Payload
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "title" ] (decodeString))
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "author" ] (decodePerson))



{-| TypeAliasDef (AliasRecordType (TypeName "Person" []) [CustomField (FieldName "name") (CustomTypeConstructor (TitleCaseDotPhrase "String") []),CustomField (FieldName "age") (CustomTypeConstructor (TitleCaseDotPhrase "Int") [])]) -}
decodePerson : Json.Decode.Decoder (Person)
decodePerson  =
    Json.Decode.succeed Person
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "name" ] (decodeString))
        |> Json.Decode.Pipeline.custom (Json.Decode.at [ "age" ] (decodeInt))