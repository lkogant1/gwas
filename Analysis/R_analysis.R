#expects as first parameter the input file (chromosome region) and as second parameter the file out

#logistic regression
library (GWAF)
args = commandArgs(trailingOnly=T);
fileIn = args[1]
fileOut = args[2]
cat ( "processing: ", fileIn, " output: ", fileOut, ".\n" );
geepack.lgst.batch(phenfile="x",genfile=fileIn, pedfile="x", phen='name', model="a", covars=c("sex","pc1","pc2","pc3","pc4"),outfile=fileOut, col.names=T, sep.ped=",", sep.phe=",", sep.gen=",")


#-------------------------
#linear mixed model
library (GWAF)
args = commandArgs(trailingOnly=T);
fileIn = args[1]
fileOut = args[2]
cat ( "processing: ", fileIn, " output: ", fileOut, ".\n" );
lmepack.batch(phenfile="x",genfile=fileIn, pedfile="x", kinmat="kinship.Rdata", phen='name', model="a", covars=c("sex","pc1","pc2","pc3","pc4"),outfile=fileOut, col.names=T, sep.ped=",", sep.phe=",", sep.gen=",")

#-------------------------