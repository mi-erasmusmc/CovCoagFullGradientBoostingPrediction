# code to create the json prediction:

populationSettings <- list(PatientLevelPrediction::createStudyPopulationSettings(riskWindowEnd = 30,
                                                                                 riskWindowStart = 1,
                                                                                 washoutPeriod = 365,
                                                                                 removeSubjectsWithPriorOutcome = TRUE,
                                                                                 firstExposureOnly = TRUE,
                                                                                 priorOutcomeLookback = 99999,
                                                                                 requireTimeAtRisk = FALSE),
                           PatientLevelPrediction::createStudyPopulationSettings(riskWindowEnd = 60,
                                                                                 riskWindowStart = 1,
                                                                                 washoutPeriod = 365,
                                                                                 removeSubjectsWithPriorOutcome = TRUE,
                                                                                 firstExposureOnly = TRUE,
                                                                                 priorOutcomeLookback = 99999,
                                                                                 requireTimeAtRisk = FALSE),
                           PatientLevelPrediction::createStudyPopulationSettings(riskWindowEnd = 90,
                                                                                 riskWindowStart = 1,
                                                                                 washoutPeriod = 365,
                                                                                 removeSubjectsWithPriorOutcome = TRUE,
                                                                                 firstExposureOnly = TRUE,
                                                                                 priorOutcomeLookback = 99999,
                                                                                 requireTimeAtRisk = FALSE))


modelList <- list(list("GradientBoostingMachineSettings" = list("maxDepth" = c(4, 6, 17),
                                                                "minRows" = c(20, 10, 5),
                                                                "ntrees" = c(10, 100, 500),
                                                                "learnRate" = c(0.01, 0.1, 0.9, 0.98),
                                                                "nthread" = c(20))))

covariateSettings <- list(list(list(fnct = 'createCovariateSettings',
                                    settings = FeatureExtraction::createCovariateSettings(useDemographicsGender = T,
                                                                                          useDemographicsAgeGroup = T,
                                                                                          useDemographicsEthnicity = T,
                                                                                          useDemographicsRace = T,
                                                                                          longTermStartDays = -365,
                                                                                          endDays = 0,
                                                                                          useConditionGroupEraLongTerm = T,
                                                                                          useDrugGroupEraLongTerm = T,
                                                                                          useProcedureOccurrenceLongTerm = T,
                                                                                          useDeviceExposureLongTerm = T,
                                                                                          useObservationLongTerm = T,
                                                                                          useMeasurementLongTerm = T)))
)

resrictOutcomePops <- NULL
resrictModelCovs <- NULL

executionSettings <- list(minCovariateFraction = 0.000,
                          normalizeData = T,
                          testSplit = "stratified",
                          testFraction = 0.20,
                          splitSeed = 1000,
                          nfold = 3)

json <- createDevelopmentStudyJson(packageName = 'CovCoagFullGradientBoostingPrediction',
                           packageDescription = 'Prediction model based on full predictor set.',
                           createdBy = 'Henrik John',
                           organizationName = 'Erasmus University Medical Center',
                           targets = data.frame(targetId = c(22956,22957,22958),
                                                cohortId = c(22956,22957,22958),
                                                targetName = c('Unvaccinated COVID19 PCR positive test or diagnosis',
                                                               'Unvaccinated COVID19 PCR positive test or diagnosis - age 65 and above',
                                                               'Unvaccinated COVID19 PCR positive test or diagnosis - age below 65')),
                           outcomes = data.frame(outcomeId = c(22601,22600,22599,22595,22596,22602,22933,22954),
                                                 cohortId = c(22601,22600, 22599,22595,22596,22602,22933,22954),
                                                 outcomeName = c('MI','IS','MI and IS','PE','DVT narrow',
                                                                 'VTE narrow', 'DTH', 'STR')),
                           populationSettings = populationSettings,
                           modelList = modelList,
                           covariateSettings = covariateSettings,
                           resrictOutcomePops = resrictOutcomePops,
                           resrictModelCovs = resrictModelCovs,
                           executionSettings = executionSettings,
                           webApi = webApi,
                           outputLocation = 'D:/hjohn/CovCoagFullGradientBoosting',
                           jsonName = 'predictionAnalysisList.json')

specifications <- Hydra::loadSpecifications(file.path('D:/hjohn/CovCoagFullGradientBoosting', 'predictionAnalysisList.json'))
Hydra::hydrate(specifications = specifications, outputFolder = 'D:/hjohn/CovCoagFullGradientBoosting/CovCoagFullGradientBoostingPrediction')
