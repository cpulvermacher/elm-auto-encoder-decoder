module Foo.Bar.Auto exposing (..)

{- this file is generated by <https://github.com/choonkeat/elm-auto-encoder-decoder> do not modify manually


imports: Set.fromList ["Dict"]
importResolver_: Dict.fromList [("Bool","Bool"),("Choice","Foo.Bar.Choice"),("Dict","Dict.Dict"),("Dict String Int","Foo.Bar.Dict String Int"),("Float","Float"),("Good String String","Foo.Bar.Good String String"),("Hello","Foo.Bar.Hello"),("Int","Int"),("List","List"),("List.List","List"),("Lookup","Foo.Bar.Lookup"),("Maybe","Maybe"),("Maybe.Maybe","Maybe"),("None","Foo.Bar.None"),("Option","Foo.Bar.Option"),("Option Bool","Foo.Bar.Option Bool"),("Payload","Foo.Bar.Payload"),("Person","Foo.Bar.Person"),("Set","Set.Set"),("Some a","Foo.Bar.Some a"),("String","String"),("String.String","String")]
file.knownTypes: Dict.fromList [("Choice",ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Option Bool"], name = TypeName "Choice" [] })),("Hello",ElmCustomType { constructors = [CustomTypeConstructor "Hello",CustomTypeConstructor "Good String String"], name = TypeName "Hello" [TypeParam "x"] }),("Lookup",ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Dict String Int"], name = TypeName "Lookup" [] })),("Option",ElmCustomType { constructors = [CustomTypeConstructor "None",CustomTypeConstructor "Some a"], name = TypeName "Option" [TypeParam "a"] }),("Payload",ElmTypeAlias (AliasRecordType (TypeName "Payload" []) [FieldPair (FieldName "title") (TypeName "String" []),FieldPair (FieldName "author") (TypeName "Person" [])])),("Person",ElmTypeAlias (AliasRecordType (TypeName "Person" []) [FieldPair (FieldName "name") (TypeName "String" []),FieldPair (FieldName "age") (TypeName "Int" [])]))]

--}

import Dict
import Foo.Bar exposing (..)
import Set
import Set
import Dict
import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


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


encodeMaybe : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
encodeMaybe encodera value =
    Maybe.map encodera value
        |> Maybe.withDefault Json.Encode.null


encodeList : (a -> Json.Encode.Value) -> List a -> Json.Encode.Value
encodeList =
    Json.Encode.list


encodeSetSet : (comparable -> Json.Encode.Value) -> Set.Set comparable -> Json.Encode.Value
encodeSetSet encoder =
    Set.toList >> encodeList encoder


encodeDictDict : (a -> Json.Encode.Value) -> (b -> Json.Encode.Value) -> Dict.Dict a b -> Json.Encode.Value
encodeDictDict keyEncoder =
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


decodeMaybe : Json.Decode.Decoder a -> Json.Decode.Decoder (Maybe a)
decodeMaybe =
    Json.Decode.maybe


decodeList : Json.Decode.Decoder a -> Json.Decode.Decoder (List a)
decodeList =
    Json.Decode.list


decodeSetSet : Json.Decode.Decoder comparable -> Json.Decode.Decoder (Set.Set comparable)
decodeSetSet =
    Json.Decode.list >> Json.Decode.map Set.fromList


decodeDictDict : Json.Decode.Decoder comparable -> Json.Decode.Decoder b -> Json.Decode.Decoder (Dict.Dict comparable b)
decodeDictDict keyDecoder valueDecoder =
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



encodeFooBarPerson : Foo.Bar.Person  -> Json.Encode.Value
encodeFooBarPerson value =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Person" []) [FieldPair (FieldName "name") (TypeName "String" []),FieldPair (FieldName "age") (TypeName "Int" [])])
    Json.Encode.object [("name", (encodeString) value.name), ("age", (encodeInt) value.age)]


encodeFooBarPayload : Foo.Bar.Payload  -> Json.Encode.Value
encodeFooBarPayload value =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Payload" []) [FieldPair (FieldName "title") (TypeName "String" []),FieldPair (FieldName "author") (TypeName "Foo.Bar.Person" [])])
    Json.Encode.object [("title", (encodeString) value.title), ("author", (encodeFooBarPerson) value.author)]


encodeFooBarOption : (a -> Json.Encode.Value) -> Foo.Bar.Option a -> Json.Encode.Value
encodeFooBarOption encodeArga value =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.None",CustomTypeConstructor "Some a"], name = TypeName "Foo.Bar.Option" [TypeParam "a"] }
    case value of
        Foo.Bar.Some arg0 -> Json.Encode.list identity [ encodeString "Foo.Bar.Some", encodeArga arg0]
        Foo.Bar.None  -> Json.Encode.list identity [ encodeString "Foo.Bar.None"]


encodeFooBarLookup : Foo.Bar.Lookup  -> Json.Encode.Value
encodeFooBarLookup value =
    -- ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Dict.Dict String Int"], name = TypeName "Foo.Bar.Lookup" [] })
    encodeDictDict encodeString encodeInt value


encodeFooBarHello : (x -> Json.Encode.Value) -> Foo.Bar.Hello x -> Json.Encode.Value
encodeFooBarHello encodeArgx value =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Hello",CustomTypeConstructor "Good String String"], name = TypeName "Foo.Bar.Hello" [TypeParam "x"] }
    case value of
        Foo.Bar.Good arg0 arg1 -> Json.Encode.list identity [ encodeString "Foo.Bar.Good", encodeString arg0, encodeString arg1]
        Foo.Bar.Hello  -> Json.Encode.list identity [ encodeString "Foo.Bar.Hello"]


encodeFooBarChoice : Foo.Bar.Choice  -> Json.Encode.Value
encodeFooBarChoice value =
    -- ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Option Bool"], name = TypeName "Foo.Bar.Choice" [] })
    encodeFooBarOption encodeBool value


decodeFooBarPerson : Json.Decode.Decoder (Foo.Bar.Person )
decodeFooBarPerson  =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Person" []) [FieldPair (FieldName "name") (TypeName "String" []),FieldPair (FieldName "age") (TypeName "Int" [])])
    Json.Decode.succeed Foo.Bar.Person |> (Json.Decode.Pipeline.custom (Json.Decode.at ["name"] (decodeString))) |> (Json.Decode.Pipeline.custom (Json.Decode.at ["age"] (decodeInt)))

decodeFooBarPayload : Json.Decode.Decoder (Foo.Bar.Payload )
decodeFooBarPayload  =
    -- ElmTypeAlias (AliasRecordType (TypeName "Foo.Bar.Payload" []) [FieldPair (FieldName "title") (TypeName "String" []),FieldPair (FieldName "author") (TypeName "Foo.Bar.Person" [])])
    Json.Decode.succeed Foo.Bar.Payload |> (Json.Decode.Pipeline.custom (Json.Decode.at ["title"] (decodeString))) |> (Json.Decode.Pipeline.custom (Json.Decode.at ["author"] (decodeFooBarPerson)))

decodeFooBarOption : Json.Decode.Decoder (a) -> Json.Decode.Decoder (Foo.Bar.Option a)
decodeFooBarOption decodeArga =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.None",CustomTypeConstructor "Some a"], name = TypeName "Foo.Bar.Option" [TypeParam "a"] }
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.Some" -> Json.Decode.succeed Foo.Bar.Some |> Json.Decode.Pipeline.custom (Json.Decode.index 1 decodeArga)
                    "Foo.Bar.None" -> Json.Decode.succeed Foo.Bar.None
                    _ ->
                        Json.Decode.fail ("Unexpected Foo.Bar.Option: " ++ word)
            )
            

decodeFooBarLookup : Json.Decode.Decoder (Foo.Bar.Lookup )
decodeFooBarLookup  =
    -- ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Dict.Dict String Int"], name = TypeName "Foo.Bar.Lookup" [] })
    decodeDictDict decodeString decodeInt

decodeFooBarHello : Json.Decode.Decoder (x) -> Json.Decode.Decoder (Foo.Bar.Hello x)
decodeFooBarHello decodeArgx =
    -- ElmCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Hello",CustomTypeConstructor "Good String String"], name = TypeName "Foo.Bar.Hello" [TypeParam "x"] }
    Json.Decode.index 0 Json.Decode.string
        |> Json.Decode.andThen
            (\word ->
                case word of
                    "Foo.Bar.Good" -> Json.Decode.succeed Foo.Bar.Good |> Json.Decode.Pipeline.custom (Json.Decode.index 1 decodeString) |> Json.Decode.Pipeline.custom (Json.Decode.index 2 decodeString)
                    "Foo.Bar.Hello" -> Json.Decode.succeed Foo.Bar.Hello
                    _ ->
                        Json.Decode.fail ("Unexpected Foo.Bar.Hello: " ++ word)
            )
            

decodeFooBarChoice : Json.Decode.Decoder (Foo.Bar.Choice )
decodeFooBarChoice  =
    -- ElmTypeAlias (AliasCustomType { constructors = [CustomTypeConstructor "Foo.Bar.Option Bool"], name = TypeName "Foo.Bar.Choice" [] })
    decodeFooBarOption decodeBool