library(tidyverse)

df <- read.csv("C:/Users/Caleb/Desktop/Bioinformatics 3000/Final Report/meme.txt", header = F)

#position-specific probability matrix

#OUT GOAL IS TO ONLY READ THE PWMs FROM DF
test <- df[which( grepl( "position-specific probability matrix", df$V1, fixed = TRUE) ),]

recording <- F #BOOLEAN FOR WHETHER OR NOT TO READ FROM THE FILE
out <- data.frame()

################################
#HEADER FOR DEFAULT MEME FORMAT
################################
out <- rbind(out, "MEME version 5.1.1")
out <- rbind(out, "")
out <- rbind(out, "ALPHABET= ACGT")
out <- rbind(out, "")
################################

for (i in df$V1){ #FOR EACH LINE IN DATAFRAME
  
  if (i %in% test){ #IF WE FIND THE HEADER FOR A PWM
    
    recording <- T #THEN START READING THE LINES
    count <- 0 #USEFUL FOR DETERMINING WHEN THE PWM IS OVER
    
  }
  
  if (recording == T){
    
    if ( grepl("--", i, fixed = T) ){ #DASHED LINES INDICATE A START AND END TO A PWM
      out <- rbind(out, "")
      count <- count + 1
      
      if (count == 2){ #IF 2 DASHED LINES ARE COUNTED
        recording <- F #THEN STOP READING FROM THE FILE
      }
      
    }
    else {
      #MORE FORMATING THAT MEME DIDNT HANDLE....
      str <- str_replace_all(i, "\t", "")
      str <- str_replace_all(str, "Motif", "MOTIF")
      str <- str_replace_all(str, "  ", " ")
      out <- rbind(out, str) #IF WERE RECORDING, ADD THE LINE TO MY FINAL OUTPUT
    }
    
  }
  
}

write.csv(out, "C:/Users/Caleb/Desktop/Bioinformatics 3000/Final Report/MEMEmotifPWM.meme", quote = F, row.names = F)
