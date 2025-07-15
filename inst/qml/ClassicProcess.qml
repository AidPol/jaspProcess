//
// Copyright (C) 2023 University of Amsterdam and Netherlands eScience Center
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls
import "./common" as Common

Form
{

	info: qsTr("Conditional process analysis allows users to test moderation and mediation effects as well as combinations of both effects. In a moderation effect, the relationship between variables *X* and *Y* differs dependening on the value of a third variable *W* (the moderator). A mediation effect is a causal chain, where the effect of *X* on *Y* goes either fully or partially through a third variable *M* (the mediator). Conditional process models combine (multiple) moderation and mediation effects.\n ### Assumptions\n\n#### Causal Assumptions\n\nFor details, see Kline (2012).\n\nConditional process models involving mediation effects are <i>causal</i> models with causal effects. <b>Interpreting model estimates as causal effects requires the causal model to be correct</b>. This implies that:\n\n- Causes must occur before their effects, e.g., if *X* → *M* → *Y*, then *X* must occur before *M* and *Y*.\n- There are no other plausible explanations (e.g., confounding variables) that can account for statistical associations between two variables.\n- The direction of causal effects is correctly specified, e.g., *X* → *M* → *Y* instead of *X* ← *M* ← *Y*.\n\nFurthermore, conditional process models in JASP are conceptualized as directed acyclic graphs (DAGs). Therefore, the model should not contain feedback loops.\n\n#### Structural Equation Model Assumptions\n\nConditional process models in JASP are conceptualized and estimated as structural equation models (SEMs), which make the following assumptions:\n\n- <b>Exogeneity</b>: The parameters of the conditional distribution of dependent (endogenous) variables given the independent (exogenous) variables should be unrelated to the parameters of the unconditional distribution of the independent variables. This implies that all omitted causes of the dependent variables are unrelated to the independent variables (pseudo-isolation).\n- <b>Local independence</b>: The absence of covariance between (the residual variances of) two dependent variables implies that, given the other variables in the model, the two variables should be independent. This implies that they have no omitted common causes.\n\n#### Data Assumptions\n\nBayesian conditional process models in JASP require all dependent (endogenous) variables in the model to follow a multivariate normal distribution. This implies that:\n\n- All univariate distributions of dependent variables should be normal.\n- All bivariate associations between dependent variables are linear.\n- The distribution of residuals does not depend on the independent variables, i.e., they are homoscedastic.")

	

	Common.VariablesForm {}

	Section
	{
		title: qsTr("Models")
		info:  qsTr("This section allows users to specify multiple process models through one of two interfaces. New models can be added by clicking the green `+` button.")
		columns: 1

		TabView
		{
			id:				models
			name:			"processModels"
			maximumItems:	10
			newItemName:	qsTr("Model 1")
			optionKey:		"name"

			content: Group
			{
				childControlsArea.anchors.leftMargin: jaspTheme.contentMargin

				Common.InputType
				{
					id: inputType
					modelName: rowValue
				}

				Common.Separator {}

				Common.InputVariables
				{
					visible: inputType.value == "inputVariables"
					adjustedWidth: models.width - 2 * jaspTheme.contentMargin
				}

				Common.InputModelNumber
				{
					visible: inputType.value == "inputModelNumber"
					adjustedWidth: models.width - 2 * jaspTheme.contentMargin
				}

				Group
				{
					id: opts
					columns: 	3

					Common.ResidualCovariances
					{
						independentCovariancesChecked: 	independentCovariancesForAllModels.checked
						mediatorCovariancesChecked: 	mediatorCovariancesForAllModels.checked
						dependentCovariancesChecked:	dependentCovariancesForAllModels.checked
					}

					Common.ParameterEstimates
					{
						pathCoefficientsChecked: 	pathCoefficientsForAllModels.checked
						interceptsChecked: 			interceptsForAllModels.checked
						mediationEffectsChecked: 	mediationEffectsForAllModels.checked
						totalEffectsChecked: 		totalEffectsForAllModels.checked
						residualCovariancesChecked: residualCovariancesForAllModels.checked
					}

					Group
					{
						title: qsTr("Tests")
						columns: 	1
						CheckBox
						{
							name: "localTests"
							label: qsTr("Local tests")
							checked: localTestsForAllModels.checked

							Label
							{
								text: qsTr("Test type")
							}
							DropDown
							{
								id: localTestType
								name: "localTestType"
								label: ""
								values:
								[
									{ label: qsTr("Linear"), 			value: "cis" 				},
									{ label: qsTr("Loess"), 			value: "cis.loess" 			},
									{ label: qsTr("Chi-square"), 		value: "cis.chisq" 			},
									{ label: qsTr("Tetrad"), 			value: "tetrads" 			},
									{ label: qsTr("Tetrad within"), 	value: "tetrads.within" 	},
									{ label: qsTr("Tetrad between"), 	value: "tetrads.between" 	},
									{ label: qsTr("Tetrad epistemic"), 	value: "tetrads.epistemic" 	}
								]
								currentValue: localTestTypeForAllModels.currentValue
							}
							CheckBox
							{
								label: qsTr("Bootstrap")
								name: "localTestBootstrap"
								checked: localTestType.currentValue == "cis.loess" || localTestBootstrapForAllModels.checked
								Label
								{
									text: qsTr("Replications")
								}
								IntegerField
								{
									name: "localTestBootstrapSamples"
									defaultValue: localTestBootstrapSamplesForAllModels.defaultValue
									min: 500
									max: 100000
								}
							}
						}
					}

					Common.PathPlots
					{
						conceptualPathPlotsChecked:		conceptualPathPlotsForAllModels.checked
						statisticalPathPlotsChecked:	statisticalPathPlotsForAllModels.checked
					}
				}
			}
		}
	}

	Section
	{
		title: qsTr("Options")
		columns: 3

		Group
		{
			CheckBox { label: qsTr("Parameter labels");				name: "parameterLabels"; 			info: qsTr("Displays the labels of parameter in the output tables. For indirect and direct (total) effects, displays the equations for the effects.") }
			CheckBox { label: qsTr("Lavaan syntax");       			name: "syntax";						info: qsTr("Shows the lavaan syntax used to fit the model in the output.") 			}
			CheckBox { label: qsTr("R-squared");       				name: "rSquared"; checked: true;	info: qsTr("Shows *R*², the proportion of variation explained in each endogenous (outcome) variable from its predictors, in the output.")	}
			CheckBox { label: qsTr("AIC weights");     				name: "aicWeights";					info: qsTr("Shows the Akaike weights in the summary table in the output.")	}
			CheckBox { label: qsTr("BIC weights");     				name: "bicWeights";					info: qsTr("Shows the Schwarz weights in the summary table in the output.")	}
			CheckBox { label: qsTr("Hayes configuration number"); 	name: "hayesNumber";  				info: qsTr("Displays the configuration number according to Hayes (2022).")	}
			CheckBox { label: qsTr("Moderated mediation index");    name: "moderatedMediationIndex";	info: qsTr("Displays the index of moderated mediation (Hayes, 2015) for each moderated indirect path in a separate table for each model. For indirect paths that have dual moderation (i.e., the same moderator moderates multiple relationships) or moderated moderation, the index cannot be calculated and is therefore omitted.")	}
		}
		Group
		{
			CheckBox
			{
				label: qsTr("Mean-centered moderation")
				name: "meanCenteredModeration"
				checked: true
				info:	qsTr("Continuous variables involved in moderation effects are mean-centered before entering the analysis. When `Missing Value Handling` is `Exclude cases listwise`, centering is applied only based on complete cases.")
			}
			CheckBox
			{
				label: qsTr("Standardized estimates")
				name: "standardizedModelEstimates"
				info:	qsTr("Adds standardized parameter estimates to the output tables. The standardization is done by multiplying the estimate with (*SD*<sub>X</sub>/*SD*<sub>Y</sub>) where *SD*<sub>X</sub> and *SD*<sub>Y</sub> are the model-implied standard deviations for the independent and dependent variable, respectively. Note that the standardization of estimates of interaction effects is based on the product of the standard deviations of the individual terms and not on the standard deviation of the product term, i.e., (*SD*<sub>X</sub>*SD*<sub>W</sub>/*SD*<sub>Y</sub>) instead of (*SD*<sub>XW</sub>/*SD*<sub>Y</sub>), where *SD*<sub>W</sub> is the model-implied standard deviation of the moderator. The estimates of (conditional) indirect and total effects are also only standardized by (*SD*<sub>X</sub>/*SD*<sub>Y</sub>) but not by standard deviations of mediators or moderators. For effects involving categorical independent variables, estimates are partially standardized, i.e., only multiplied by *SD*<sub>Y</sub>. Conditional effects are probed on the unstandardized scale of moderators. See Cheung and Cheung (2023) for details.")
			}
		}
		Group
		{
			CIField {
				text: qsTr("Confidence intervals")
				name: "ciLevel"
				info:	qsTr("The level of confidence intervals for parameter estimates in the output tables.")
			}
			RadioButtonGroup {
				title: qsTr("Method")
				name: "errorCalculationMethod"
				RadioButton { text: qsTr("Standard")  ; name: "standard" ; checked: true; 	info: qsTr("Calculates standard errors and confidence intervals based on the inverted expected information matrix.") }
				RadioButton { text: qsTr("Robust")    ; name: "robust";						info: qsTr("Calculates robust standard errors and confidence intervals.") }
				RadioButton {
					text: qsTr("Bootstrap")
					name: "bootstrap"
					info: qsTr("Calculates bootstrap standard errors and confidence intervals.")
					IntegerField {
						text: qsTr("Replications")
						name: "bootstrapSamples"
						info: qsTr("Number of bootstrap replications.")
						defaultValue: 1000
						min: 500
						max: 100000
					}
					DropDown {
						label: qsTr("Type")
						name: "bootstrapCiType"
						info: qsTr("Type of bootstrap.")
						values: [
							{ label: qsTr("Percentile"),                value: "percentile"         },
							{ label: qsTr("Bias-corrected percentile"), value: "percentileBiasCorrected"   },
							{ label: qsTr("Normal theory"),             value: "normalTheory"         }
						]
					}
				}
			}
		}
	}

	Section
	{
		title: qsTr("Plots")
		columns: 1

		CheckBox
		{
			name: 		"useColorPalette"
			label: 		qsTr("Color palette")
			info:		qsTr("Color palette for node colors.")
			checked: 	true
			childrenOnSameRow: true

			ColorPalette
			{
				name: "colorPalette"
				label: ""
			}
		}

		Common.PathPlotOptions {}
	}

	Section
	{
		id: advanced
		title: qsTr("Advanced")
		columns: 1

		Group
		{
			title: qsTr("Set for All Models")
			info:  qsTr("Sets options for all models at the same time. See `Models`.")
			columns: 4
			preferredWidth: parent.width

			Group
			{
				title: qsTr("Residual Covariances")
				CheckBox
				{
					id:			independentCovariancesForAllModels
					name: 		"independentCovariancesForAllModels"
					label: 		qsTr("Independent variables")
					checked:	true
				}
				CheckBox
				{
					id:			mediatorCovariancesForAllModels
					name: 		"mediatorCovariancesForAllModels"
					label: 		qsTr("Mediators")
				}
				CheckBox
				{
					id:			dependentCovariancesForAllModels
					name: 		"dependentCovariancesForAllModels"
					label: 		qsTr("Dependent variables")
				}
			}

			Group
			{
				title: qsTr("Parameter Estimates")
				columns: 1

				CheckBox
				{
					id:			pathCoefficientsForAllModels
					name: 		"pathCoefficientsForAllModels"
					label: 		qsTr("Paths")
					checked: 	true

					CheckBox
					{
						id:			interceptsForAllModels
						name: 		"interceptsForAllModels"
						label: 		qsTr("Intercepts")
					}
				}
				CheckBox
				{
					id:			mediationEffectsForAllModels
					name: 		"mediationEffectsForAllModels"
					label: 		qsTr("Indirect")
					checked: 	true
				}
				CheckBox
				{
					id:			totalEffectsForAllModels
					name: 		"totalEffectsForAllModels"
					label: 		qsTr("Total")
					checked: 	true
				}
				CheckBox
				{
					id:			residualCovariancesForAllModels
					name: 		"residualCovariancesForAllModels"
					label: 		qsTr("Residual covariances")
				}
			}

			Group
			{
				title: qsTr("Path Plots")
				CheckBox
				{
					id:			conceptualPathPlotsForAllModels
					name: 		"conceptualPathPlotsForAllModels"
					label: 		qsTr("Conceptual")
					checked: 	true
				}
				CheckBox
				{
					id:			statisticalPathPlotsForAllModels
					name: 		"statisticalPathPlotsForAllModels"
					label: 		qsTr("Statistical")
				}
			}

			Group
			{
				title: qsTr("Tests")
				columns: 	1
				CheckBox
				{
					id: localTestsForAllModels
					name: "localTestsForAllModels"
					label: qsTr("Local tests")

					Label
					{
						text: qsTr("Test type")
					}
					DropDown
					{
						id: localTestTypeForAllModels
						name: "localTestTypeForAllModels"
						label: ""
						values:
						[
							{ label: qsTr("Linear"), 			value: "cis" 				},
							{ label: qsTr("Loess"), 			value: "cis.loess" 			},
							{ label: qsTr("Chi-square"), 		value: "cis.chisq" 			},
							{ label: qsTr("Tetrad"), 			value: "tetrads" 			},
							{ label: qsTr("Tetrad within"), 	value: "tetrads.within" 	},
							{ label: qsTr("Tetrad between"), 	value: "tetrads.between" 	},
							{ label: qsTr("Tetrad epistemic"), 	value: "tetrads.epistemic" 	}
						]
					}
				}
				CheckBox
				{
					id: localTestBootstrapForAllModels
					label: qsTr("Bootstrap")
					name: "localTestBootstrapForAllModels"
					checked: localTestTypeForAllModels.currentValue == "cis.loess"
					Label
					{
						text: qsTr("Replications")
					}
					IntegerField
					{
						id: localTestBootstrapSamplesForAllModels
						name: "localTestBootstrapSamplesForAllModels"
						defaultValue: 1000
						min: 500
						max: 100000
					}
				}
				Label
				{
					text: qsTr("Adjustment method")
				}
				DropDown
				{
					name: "localTestCorrectionForAllModels"
					label: ""
					values:
					[
						{ label: qsTr("None"), 					value: "none" 		},
						{ label: qsTr("Holm"), 					value: "holm" 		},
						{ label: qsTr("Hochberg"), 				value: "hochberg" 	},
						{ label: qsTr("Hommel"), 				value: "hommel" 	},
						{ label: qsTr("Bonferroni"), 			value: "bonferroni" },
						{ label: qsTr("Benjamini-Hochberg"), 	value: "BH" 		},
						{ label: qsTr("Benjamini-Yekuteli"), 	value: "BY" 		}
					]
					startValue: "bonferroni"
				}
			}
		}

		Group
		{
			columns: 3

			RadioButtonGroup
			{
				title: qsTr("Missing Value Handling")
				name: "naAction"
				RadioButton { text: qsTr("Exclude cases listwise")              ; name: "listwise" ; checked: true; info:	qsTr("Only use complete cases in the model.")	}
				RadioButton { text: qsTr("Full Information Maximum Likelihood") ; name: "fiml";  					info:	qsTr("Computes the likelihood case-by-case using all available data. Only allowed when `Estimator` is `Auto` or `ML`. This option forces the model to add a mean structure increasing the number of parameters in the model and affecting fit indices (AIC and BIC).")	}
			}
			RadioButtonGroup
			{
				title: qsTr("Emulation")
				name: "emulation"
				info:  qsTr("Sets the default values corresponding to different SEM software.")
				RadioButton { text: qsTr("None")  ; name: "lavaan"  ; checked: true }
				RadioButton { text: qsTr("Mplus") ; name: "mplus" }
				RadioButton { text: qsTr("EQS")   ; name: "eqs"   }
			}
			RadioButtonGroup
			{
				title: qsTr("Estimator")
				name: "estimator"
				info:  qsTr("The estimator for the SEMs. See lavaan manual.")
				RadioButton { text: qsTr("Auto") ; name: "default"; checked: true }
				RadioButton { text: qsTr("ML")   ; name: "ml"       }
				RadioButton { text: qsTr("GLS")  ; name: "gls"      }
				RadioButton { text: qsTr("WLS")  ; name: "wls"      }
				RadioButton { text: qsTr("ULS")  ; name: "uls"      }
				RadioButton { text: qsTr("DWLS") ; name: "dwls"     }
			}
		}

		Common.ModerationProbes {}
	}
}
