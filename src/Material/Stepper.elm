module Material.Stepper
  exposing
    ( stepper, horizontal, vertical, activeStep
    , step, completed, title
    )

import Platform.Cmd exposing (Cmd, none)
import Html exposing (Html, Attribute)
import Parts exposing (Indexed)
import Html.Attributes as Html exposing (class)
import Html.Events as Html
import Html.App
import Platform.Cmd exposing (Cmd, none)
import Material.Icon as Icon
import Material.Options as Options exposing (Property, cs, css, when, nop)


-- Stepper

type Orientation =
    Horizontal | Vertical

type alias Stepper =
    { activeStep : Int
    , orientation : Orientation
    }

defaultStepper : Stepper
defaultStepper =
    { activeStep = 0
    , orientation = Horizontal
    }


stepper : List (Property Stepper m) -> List (Step m) -> Html m
stepper options steps =
    let
        ({ config } as summary) =
            Options.collect defaultStepper options
    in
        Options.apply summary Html.ul
            [ cs "mdl-stepper"
            , case config.orientation of
                  Horizontal -> cs "mdl-stepper--horizontal"
                  Vertical -> cs "mdl-stepper-vertical"
            ]
            [
            ]
            <| List.indexedMap (\idx (opts,conf) ->
                                    let
                                        opts' =
                                            opts ++ [ index idx
                                                    , active `when` (config.activeStep == idx)
                                                    ]
                                    in
                                        step' opts' conf
                               )
                steps

horizontal : Property { a | orientation : Orientation} m
horizontal =
    Options.set <| \self -> { self | orientation = Horizontal }

vertical : Property { a | orientation : Orientation} m
vertical =
    Options.set <| \self -> { self | orientation = Vertical }


{-| Set the active step.
 -}
activeStep : Int -> Property Stepper m
activeStep idx =
    Options.set (\config -> { config | activeStep = idx })

-- Step

type Status
    = Incomplete
    | Completed
    | Error String

type alias StepConfig m =
    { index : Int
    , title : String
    , subtitle : Maybe String
    , status : Status
    , active : Bool
    , onClick : Maybe (Attribute m)
    }

defaultStep : StepConfig m
defaultStep =
    { index = 0
    , title = ""
    , subtitle = Nothing
    , status = Incomplete
    , active = False
    , onClick = Nothing
    }

type alias Step m
    = (List (Property (StepConfig m) m), List (Html m))

step : List (Property (StepConfig m) m) -> List (Html m) -> Step m
step options html = (options, html)

{-| Stepper `step`
 -}
step' : List (Property (StepConfig m) m) -> List (Html m) -> Html m
step' options html =
    let
        ({ config } as summary) =
            Options.collect defaultStep options
    in
        Options.apply summary Html.li
            [ cs "mdl-step"
            , cs "is-active" `when` config.active
            , case config.status of
                  Incomplete -> nop
                  Completed -> cs "mdl-step--completed"
                  Error _ -> cs "mdl-step--error"
            ]
            -- TODO: Can I do this w/o parens?
            (config.onClick
                |> Maybe.map (flip (::) [])
                |> Maybe.withDefault [])
            [ Options.span
                  [ cs "mdl-step__label "]
                  [ Options.span
                            [ cs "mdl-step__title" ]
                            [ Options.span
                                  [ cs "mdl-step__title-text" ]
                                  [ Html.text config.title ]
                            ]
                  , Options.span
                      [ cs "mdl-step__label-indicator" ]
                      [ Options.span
                            [ cs "mdl-step__label-indicator-content" ]
                            [ (case config.status of
                                   Completed ->
                                       Icon.i "check"

                                   _ ->
                                       Html.text <| toString (config.index + 1))
                            ]
                      ]
                  ]
            , Options.div
                [ cs "mdl-step__content" ]
                html
            ]


onClick : m -> Property { a | onClick : Maybe (Attribute m) } m
onClick x =
    Options.set (\options -> { options | onClick = Just (Html.onClick x) })

index : Int -> Property (StepConfig m) m
index idx =
    Options.set <| \self -> { self | index  = idx }

title : String -> Property (StepConfig m) m
title t =
    Options.set <| \self -> { self | title = t }

subtitle : String -> Property (StepConfig m) m
subtitle st =
    Options.set <| \self -> { self | subtitle = Just st }

active : Property (StepConfig m) m
active =
    Options.set <| \self -> { self | active = True }

status : Status -> Property (StepConfig m) m
status s =
    Options.set <| \self -> { self | status = s}

completed : Property (StepConfig m) m
completed =
    status Completed



















-- view : (Msg -> m) -> Model -> List (Property m) -> List (Step m) -> List (Html m) -> Html m
-- view lift model options steps stepContent =
--     let
--         summary =
--             Options.collect defaultConfig options

--         config =
--             summary.config

--         unwrapStep stepIdx (Step ( props, content )) =
--             let
--                 stepSummary =
--                     Options.collect Step.defaultConfig props

--                 stepConfig =
--                     stepSummary.config
--             in
--             Options.styled Html.li
--                 ([ cs "mdl-step"
--                  , cs "mdl-step--completed" `when` stepConfig.completed
--                  , cs "is-active" `when` (stepIdx == config.activeStep)
--                  , config.onSelectStep
--                      |> Maybe.map (\t -> Internal.attribute <| Html.onClick (t stepIdx))
--                      |> Maybe.withDefault Options.nop
--                  ]
--                      ++ props
--                 )
--                 [ Options.span
--                     [ cs "mdl-step__label "]
--                     <| List.concat
--                       [ content
--                       , [ Options.span
--                           [ cs "mdl-step__label-indicator" ]
--                           [ Options.span
--                                 [ cs "mdl-step__label-indicator-content" ]
--                                 [ (if stepConfig.completed then
--                                        Icon.i "check"
--                                    else
--                                        Html.text <| toString (stepIdx + 1)
--                                   )
--                                 ]
--                           ]
--                         ]
--                       ]
--                 , Options.div
--                     [ cs "mdl-step__content" ]
--                     stepContent
--                 -- TODO: Actions!
--                 ]
--     in
--         Options.apply summary
--             Html.ul
--                 [ cs "mdl-stepper" ]
--                 []
--                 (List.indexedMap unwrapStep steps)



-- {-| Create stepper `step` with a simple title.
--  -}
-- -- titleStep : List (Step.Property m) -> String -> Step m
-- -- titleStep p t =
-- --     step p [ Options.span
-- --                   [ cs "mdl-step__title" ]
-- --                   [ Options.span [ cs "mdl-step__title-text" ] [ Html.text t ] ]
-- --             ]

-- -- COMPONENT


-- type alias Container c =
--     { c | stepper : Indexed Model }


-- {-| Component render.
--  -}
-- render :
--     (Parts.Msg (Container c) m -> m)
--     -> Parts.Index
--     -> Container c
--     -> List (Property m)
--     -> List (Step m)
--     -> List (Html m)
--     -> Html m
-- render =
--     Parts.create
--         view (Parts.generalize update)
--         .stepper (\x y -> { y | stepper = x }) defaultModel
