import Html exposing (Html, div, text, ul, li, a)
import Html.Attributes exposing (class, href)
import Html.App
import Content.Main as Content
import Routing
import Navigation


-- MODEL


type alias AppModel =
    { contentModel : Content.Model
    , route : Routing.Route
    }


initialModel : Routing.Route -> AppModel
initialModel route =
    { contentModel = Content.initialModel
    , route = route
    }


init : Result String Routing.Route  -> ( AppModel, Cmd Msg )
init result =
    let
      currentRoute =
        Routing.routeFromResult result
    in
      ( initialModel currentRoute, Cmd.none )

-- MESSAGES


type Msg
    = ContentMsg Content.Msg



-- VIEW

renderMainMenu : Html Msg
renderMainMenu =
    div [ class "main-menu" ] [
      ul [ class "list" ] [
        li [] [
          a [ href "#about" ] [
            text "About"
          ]
        ],
        li [] [
          a [ href "#offer" ] [
            text "Offer"
          ]
        ]
      ]
    ]

view : AppModel -> Html Msg
view model =
    case model.route of
      Routing.OfferRoute ->
        div [ class "viewport" ] [
          renderMainMenu,
          div [] [
            Html.App.map ContentMsg (Content.view model.contentModel)
          ]
        ]
      Routing.AboutRoute ->
        div [ class "viewport" ] [
          renderMainMenu,
          div [] [
            div [ class "content" ] [ text "About route" ]
          ]
        ]
      Routing.NotFoundRoute ->
        div [] [ text "Not found" ]




-- UPDATE


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        ContentMsg subMsg ->
            let
                ( updatedContentModel, contentCmd ) =
                    Content.update subMsg model.contentModel
            in
                ( { model | contentModel = updatedContentModel }, Cmd.map ContentMsg contentCmd )



-- SUBSCIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.none



-- APP

urlUpdate : Result String Routing.Route -> AppModel -> ( AppModel, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        ( { model | route = currentRoute }, Cmd.none )

main : Program Never
main =
    Navigation.program Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
