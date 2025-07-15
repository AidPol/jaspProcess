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
	info:  qsTr("Bayesian conditional process analysis allows users to test moderation and mediation effects as well as combinations of both effects. In a moderation effect, the relationship between variables *X* and *Y* differs dependening on the value of a third variable *W* (the moderator). A mediation effect is a causal chain, where the effect of *X* on *Y* goes either fully or partially through a third variable *M* (the mediator). Conditional process models combine (multiple) moderation and mediation effects.\n ### Assumptions\n\n#### Causal Assumptions\n\nFor details, see Kline (2012).\n\nConditional process models involving mediation effects are <i>causal</i> models with causal effects. <b>Interpreting model estimates as causal effects requires the causal model to be correct</b>. This implies that:\n\n- Causes must occur before their effects, e.g., if *X* → *M* → *Y*, then *X* must occur before *M* and *Y*.\n- There are no other plausible explanations (e.g., confounding variables) that can account for statistical associations between two variables.\n- The direction of causal effects is correctly specified, e.g., *X* → *M* → *Y* instead of *X* ← *M* ← *Y*.\n\nFurthermore, conditional process models in JASP are conceptualized as directed acyclic graphs (DAGs). Therefore, the model should not contain feedback loops.\n\n#### Structural Equation Model Assumptions\n\nConditional process models in JASP are conceptualized and estimated as structural equation models (SEMs), which make the following assumptions:\n\n- <b>Exogeneity</b>: The parameters of the conditional distribution of dependent (endogenous) variables given the independent (exogenous) variables should be unrelated to the parameters of the unconditional distribution of the independent variables. This implies that all omitted causes of the dependent variables are unrelated to the independent variables (pseudo-isolation).\n- <b>Local independence</b>: The absence of covariance between (the residual variances of) two dependent variables implies that, given the other variables in the model, the two variables should be independent. This implies that they have no omitted common causes.\n\n#### Data Assumptions\n\nBayesian conditional process models in JASP require all dependent (endogenous) variables in the model to follow a multivariate normal distribution. This implies that:\n\n- All univariate distributions of dependent variables should be normal.\n- All bivariate associations between dependent variables are linear.\n- The distribution of residuals does not depend on the independent variables, i.e., they are homoscedastic.")

	

	
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
                Group {
					Layout.leftMargin: jaspTheme.contentMargin

					Common.InputType
					{
						id: inputType
						modelName: rowValue
					}

                    Common.Separator {}

                    Common.InputVariables {
						visible: inputType.value == "inputVariables"
						adjustedWidth: models.width - 2 * jaspTheme.contentMargin
					}

                    Common.InputModelNumber {
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

						Common.PathPlots
						{
							conceptualPathPlotsChecked:		conceptualPathPlotsForAllModels.checked
							statisticalPathPlotsChecked:	statisticalPathPlotsForAllModels.checked
						}
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
			CheckBox 
			{
				label: qsTr("Prior distributions")
				name: "priorDistributions"
				info:  qsTr("Shows the prior distributions for path coefficients in the output. The distributions can be modified in the `Advanced` section.")
			}
			CheckBox 
			{
				label: qsTr("Parameter labels")
				name: "parameterLabels"
				info:  qsTr("Displays the labels of parameter in the output tables. For indirect and direct (total) effects, displays the equations for the effects.")
			}
			CheckBox 
			{
				label: qsTr("Lavaan syntax")
				name: "syntax"
				info:  qsTr("Shows the lavaan syntax used to fit the model in the output.")
			}
			CheckBox 
			{
				label: qsTr("BIC weights")
				name: "bicWeights"
				info:  qsTr("Shows the Schwarz weights in the summary table in the output.")
			}
			CheckBox 
			{
				label: qsTr("Hayes configuration number")
				name: "hayesNumber"
				info:  qsTr("Displays the configuration number according to Hayes (2022).")
			}
		}

		Group
		{
			IntegerField
			{
				name:			"mcmcBurnin"
				id:				warmup
				label:			qsTr("Burnin")
				info:  			qsTr("Number of burnin samples drawn for each MCMC chain.")
				defaultValue:	500
				min:			100
			}

			IntegerField
			{
				name:			"mcmcSamples"
				label:			qsTr("Samples")
				info:  			qsTr("Number of samples drawn for each MCMC chain.")
				defaultValue:	1000
				min:			parseInt(warmup.value) + 100
			}

			IntegerField
			{
				name:			"mcmcChains"
				label:			qsTr("Chains")
				info:  			qsTr("Number of chains in the MCMC algorithm.")
				defaultValue:	3
				min:			1
			}
		}

		Group
		{
			SetSeed {}

			CIField 
			{
				text: qsTr("Credible intervals")
				name: "ciLevel"
				info: qsTr("The level of credible intervals in the output tables. Credible intervals are based on quantiles of the posterior samples.")
			}
			
			CheckBox
			{
				label: qsTr("Mean-centered moderation")
				name: "meanCenteredModeration"
				info:  qsTr("Continuous variables involved in moderation effects are mean-centered before entering the analysis. When `Missing Value Handling` is `Exclude cases listwise`, centering is applied only based on complete cases.")
				checked: true
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
			info:		qsTr("Color palette for plots.")
			checked: 	true
			childrenOnSameRow: true

			ColorPalette
			{
				name: "colorPalette"
				label: ""
			}
		}

		Common.PathPlotOptions {}

		Group
		{
			title: qsTr("MCMC Plots")
			columns: 2
			Group
			{
				CheckBox { name: "aggregatedChains";	label: qsTr("Aggregate chains for densities and histograms"); 	info:	qsTr("If checked, the samples of different chains are aggregated in density plots and histograms. If unchecked, there are separate colors per chain.");	checked:true	}
				CheckBox { name: "legend";				label: qsTr("Show legends");									info:	qsTr("Shows legends");																																	checked:true	}
				CheckBox { name: "densityPlot";			label: qsTr("Density");											info:	qsTr("Shows a density plot of the posterior samples.")																													}
				CheckBox { name: "histogramPlot";		label: qsTr("Histogram");										info:	qsTr("Shows a histogram of the posterior samples.")																														}
				CheckBox { name: "tracePlot";			label: qsTr("Trace");											info:	qsTr("Shows a trace plot of the posterior samples.")																													}
			}
			Group
			{
				columns: 2
				CheckBox { label: qsTr("Autocorrelation");	name: "autoCorPlot"; id: autoCorrelation; info: qsTr("Plots the autocorrelation of the posterior samples.")
					IntegerField
					{
						name: "autoCorPlotLags"
						label: qsTr("No. lags")
						info:  qsTr("Sets the maximum number of lags to show in the autocorrelation plot.")
						defaultValue: 20
						min: 1
						max: 100
					}
					RadioButtonGroup
					{
						name: "autoCorPlotType"
						title: qsTr("Type")
						RadioButton { value: "lines";	label: qsTr("line"); info:("Display the autocorrelation as a line that connects subsequent lags"); checked:true	}
						RadioButton { value: "bars";	label: qsTr("bar");	 info:("Display the autocorrelation as a bar at each lag")									}
					}
				}
				CheckBox { label: qsTr("Bivariate scatter");  name: "bivariateScatterPlot"; info: qsTr("Shows a bivariate scatter plot of all pairs of variables. Only shows output when more than 1 parameter is sampled."); id: bivariateScatter
					RadioButtonGroup
					{
						name: "bivariateScatterDiagonalType"
						title: qsTr("Diagonal plot type")
						RadioButton { value: "density";		label: qsTr("Density"); 	info: qsTr("Show a density plot on the diagonal entries of the scatter plot."); checked:true	}
						RadioButton { value: "histogram";	label: qsTr("Histogram"); 	info: qsTr("Shows a histogram on the diagonal entries of the scatter plot.")					}
					}
					RadioButtonGroup
					{
						name: "bivariateScatterOffDiagonalType"
						title: qsTr("Off-diagonal plot type")
						RadioButton { value: "hexagon";		label: qsTr("Hexagonal"); info: qsTr("Shows a hexagonal bivariate density plot on the off-diagonal entries of the scatter plot."); checked:true	}
						RadioButton { value: "contour";		label: qsTr("Contour");   info: qsTr("Shows a contour plot on the off-diagonal entries of the scatter plot.")									}
					}
				}
			}
		}
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
                    label: 		qsTr("Mediation")
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
		}

		Group
		{
			title: qsTr("Prior distributions")
			info:  qsTr("Sets prior distributions for different types of parameters.")

			columns: 1

			Group
			{
				columns: 4

				Label
				{
					text: qsTr("Intercepts:")
					//info: qsTr("Location and scale parameters of normal priors on intercepts (v).")
				}
				Label
				{
					text: qsTr("v ~ Normal(μ,σ)")
				}
				FormulaField
				{
					name: "nuPriorMu"
					label: "μ"
					value: "0"
					fieldWidth: 40 * preferencesModel.uiScale
				}
				FormulaField
				{
					name: "nuPriorSigma"
					label: "σ"
					value: "32"
					min: 0
					inclusive: JASP.None
					fieldWidth: 40 * preferencesModel.uiScale
				}
				
				Label
				{
					text: qsTr("Path coefficients:")
					//info: qsTr("Location and scale parameters of normal priors on path coefficients (β).")
				}
				Label
				{
					text: qsTr("β ~ Normal(μ,σ)")
				}
				FormulaField
				{
					name: "betaPriorMu"
					label: "μ"
					value: "0"
					fieldWidth: 40 * preferencesModel.uiScale
				}
				FormulaField
				{
					name: "betaPriorSigma"
					label: "σ"
					value: "10"
					min: 0
					inclusive: JASP.None
					fieldWidth: 40 * preferencesModel.uiScale
				}

				Label
				{
					text: qsTr("Standard deviations:")
					//info: qsTr("Shape and rate parameters of gamma priors on standard deviations of the decomposed covariance matrix.")
				}
				Label
				{
					text: qsTr("ψ ~ Gamma(α,β)")
				}
				FormulaField
				{
					name: "psiPriorAlpha"
					label: "α"
					value: "1.0"
					min: 0
					inclusive: JASP.None
					fieldWidth: 40 * preferencesModel.uiScale
				}
				FormulaField
				{
					name: "psiPriorBeta"
					label: "β"
					value: "0.5"
					min: 0
					inclusive: JASP.None
					fieldWidth: 40 * preferencesModel.uiScale
				}

				Label
				{
					text: qsTr("Correlations:")
					//info: qsTr("Shape and rate parameters of gamma priors on correlations of the decomposed covariance matrix.")
				}
				Label
				{
					text: qsTr("ρ ~ Beta(α,β)")
				}
				FormulaField
				{
					name: "rhoPriorAlpha"
					label: "α"
					value: "1"
					min: 0
					inclusive: JASP.None
					fieldWidth: 40 * preferencesModel.uiScale
				}
				FormulaField
				{
					name: "rhoPriorBeta"
					label: "β"
					value: "1"
					min: 0
					inclusive: JASP.None
					fieldWidth: 40 * preferencesModel.uiScale
				}
			}
		}

		Common.ModerationProbes {}
    }
}
