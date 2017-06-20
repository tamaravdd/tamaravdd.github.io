* usecda- version 1.1 

capture 	program drop usecda
program 	define usecda
args 		data 
use			https://tamaravdd.github.io/icpsrcda/`data'.dta, clear
end
