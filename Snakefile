## Driver script for the deconvolution assessment pipeline
##
## @zgr2788
##
##
## Description:
## This file is essentially a driver for the different modules that are
## a part of the deconvolution assessment network.
##
##
##
##
##
##
##
##
##
##
##
##


#Helper functions to fetch inputs from prep module
def getBulks():
    inList = []

    if config['seededRun']:
        seedStatus = "_seeded"
    else:
        seedStatus = ""

    if config["stParam"]['scaleFirst']:
        st = "_scaled_transformed"
    else:
        st = "_transformed_scaled"

    filename_T = str("Input/Normalized_tables/" + config['sampleName'] + "_pbulks" + seedStatus + st + ".rds")
    filename_P = str("Input/Psuedobulks/" + config['sampleName'] + "_props" + seedStatus + ".rds")

    inList.append(filename_T)
    inList.append(filename_P)

    return inList


def getC2(inList):
    if config['seededRun']:
        seedStatus = "_seeded"
    else:
        seedStatus = ""

    filename_C2 = str("Input/References/" + config["sampleName"] + "_C2" + seedStatus + ".rds")

    inList.append(filename_C2)

    return inList


def getC1(inList):
        if config['seededRun']:
            seedStatus = "_seeded"
        else:
            seedStatus = ""

        filename_C1 = str("Input/References/" + config["sampleName"] + "_C1" + seedStatus + ".rds")

        inList.append(filename_C1)

        return inList


def getRefVar(inList):
        if config['seededRun']:
            seedStatus = "_seeded"
        else:
            seedStatus = ""

        filename_refVar = str("Input/References/" + config["sampleName"] + "_refVar" + seedStatus + ".rds")

        inList.append(filename_refVar)

        return inList



configfile: 'config.yaml'

#Prep metamodule
include: "Modules/Convert_split/Snakefile"
include: "Modules/Psuedobulk/Snakefile"
include: "Modules/C_generation/Snakefile"
include: "Modules/Scale_transform/Snakefile"

#Deconv metamodule
include: "Modules/debCAM/Snakefile"
include: "Modules/CDSeq/Snakefile"
include: "Modules/DeconRNASeq/Snakefile"
include: "Modules/OLS/Snakefile"
include: "Modules/NNLS/Snakefile"
include: "Modules/CIBERSORT/Snakefile"
include: "Modules/RLR/Snakefile"
include: "Modules/FARDEEP/Snakefile"
include: "Modules/DCQ/Snakefile"
include: "Modules/elasticNET/Snakefile"
include: "Modules/lasso/Snakefile"
include: "Modules/ridge/Snakefile"
include: "Modules/EPIC/Snakefile"
include: "Modules/dtangle/Snakefile"
include: "Modules/CellMix/Snakefile"
include: "Modules/ADAPTS/Snakefile"

outFile = list()
inP = "Input/Psuedobulks/" + config['sampleName']
inC = "Input/References/" + config['sampleName']
inN = "Input/Normalized_tables/" + config['sampleName']


if not config['seededRun']:
    props = inP + '_props.rds'
    c1 = inC + '_C1.rds'
    c2 = inC + '_C2.rds'
    refvar = inC + '_refVar.rds'
    c0 = inN + '_C0'
    pbulks = inN + '_pbulks'

    if config["stParam"]["scaleFirst"]:
        c0 = c0 + '_scaled_transformed.rds'
        pbulks = pbulks + '_scaled_transformed.rds'

    else:
        c0 = c0 + '_transformed_scaled.rds'
        pbulks = pbulks + '_transformed_scaled.rds'


else:
    props = inP + '_props_seeded.rds'
    c1 = inC + '_C1_seeded.rds'
    c2 = inC + '_C2_seeded.rds'
    refvar = inC + '_refVar_seeded.rds'
    c0 = inN + '_C0_seeded'
    pbulks = inN + '_pbulks_seeded'

    if config["stParam"]["scaleFirst"]:
        c0 = c0 + '_scaled_transformed.rds'
        pbulks = pbulks + '_scaled_transformed.rds'

    else:
        c0 = c0 + '_transformed_scaled.rds'
        pbulks = pbulks + '_transformed_scaled.rds'


outFile.append(pbulks)
outFile.append(props)
outFile.append(c0)
outFile.append(c1)
outFile.append(c2)
outFile.append(refvar)


rule all:
    input:
        #outFile,
        "Output/Hrvatin_afteint_debCAM_unsupervised.txt",
        "Output/Hrvatin_afteint_debCAM_marker.txt",
        "Output/Hrvatin_afteint_debCAM_C1.txt",
        "Output/Hrvatin_afteint_CDSeq.txt",
        "Output/Hrvatin_afteint_DeconRNASeq.txt",
        "Output/Hrvatin_afteint_OLS.txt",
        "Output/Hrvatin_afteint_NNLS.txt",
        "Output/Hrvatin_afteint_CIBERSORT.txt",
        "Output/Hrvatin_afteint_RLR.txt",
        "Output/Hrvatin_afteint_FARDEEP.txt",
        "Output/Hrvatin_afteint_DCQ.txt",
        "Output/Hrvatin_afteint_elasticNET.txt",
        "Output/Hrvatin_afteint_lasso.txt",
        "Output/Hrvatin_afteint_ridge.txt",
        "Output/Hrvatin_afteint_EPIC.txt",
        "Output/Hrvatin_afteint_dtangle.txt",
        "Output/Hrvatin_afteint_DSA.txt",
        "Output/Hrvatin_afteint_deconf.txt",
        "Output/Hrvatin_afteint_ssKL.txt",
        "Output/Hrvatin_afteint_ssFrobenius.txt",
        "Output/Hrvatin_afteint_ADAPTS.txt"

#    output:
#        "passPrep"
#
#    shell:
#        " printf -- 'Delete this file to reactivate the deconvolution preparation module.' > passPrep "
