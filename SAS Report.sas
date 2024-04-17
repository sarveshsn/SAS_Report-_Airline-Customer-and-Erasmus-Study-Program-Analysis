

/* COVER PAGE */
options nodate nonumber; 
ods escapechar='^';
proc odstext;
p '^{newline 15}';
p "SAS PROJECT REPORT" /
style=[font_size= 20pt fontweight=bold just= c];
p "Sarvesh Sairam Naik" /
style=[font_size= 18pt just= c];
p '^{newline 15}';
style=[font_size= 14pt font_style= italic just= c];
run;

/**********************************************************************************/

title1 c=stb bcolor=lightblue Height=16pt " Data Analysis I ";
footnote height=10pt "";
title2 " ";
title3 c=stb bcolor=aliceblue Height=14pt " Importing the dataset. ";
footnote height=10pt "About the dataset :
Customer satisfaction scores from 120,000+ airline passengers, including additional information about each passenger, 
their flight, and type of travel, as well as ther evaluation of different factors like cleanliness, 
comfort, service, and overall experience.";

/* Importing the dataset */
PROC IMPORT DATAFILE="/home/u63441807/Course/Final Project/airline_passenger_satisfaction.csv"
            OUT=Passengers
            DBMS=CSV
            REPLACE;
            GETNAMES=YES;
RUN;


PROC print data=Passengers (obs=5);
RUN;

/*****************************************************************************************/

title1 c=stb bcolor=aliceblue Height=14pt "Which percentage of airline passengers are satisfied? 
Does it vary by customer type? What about type of travel?";
footnote height=1pt " ";

title2 "";
title3 c=stb bcolor=whitesmoke Height=12pt "Satisfaction Percentage by Overall";
footnote height=1pt " ";
/* Calculating Satisfaction Percentage by Overall*/
options validvarname=any;
PROC FREQ DATA=Passengers;
    TABLES Satisfaction / OUT=overall_satisfaction(KEEP=LABEL COUNT PERCENT);
RUN;
PROC PRINT DATA=overall_satisfaction;
    TITLE '';
    footnote height=10pt "From the tables shown above we can infer that about 73452 that is 56.5537% of 
airline customers are Neutral or Dissatisfied with the overall service. And remaining 56428 or 43.4463% of 
the customers are satisfied by the overall service. ";
RUN;


title c=stb bcolor=whitesmoke Height=12pt "Satisfaction Percentage by Customer Type";
footnote height=1pt "";
/*Calculating Satisfaction Percentage by Customer Type*/
options validvarname=any;
PROC FREQ DATA=Passengers;
    TABLES Satisfaction*"Customer Type"n / OUT=customer_type_satisfaction(KEEP=LABEL "Customer Type"n COUNT PERCENT);
RUN;
PROC PRINT DATA=customer_type_satisfaction;
    TITLE '';
    footnote height=10pt "We can infer from the dataset that about First-time customers who account to about 13.9205% and 
    Returning customers who account to 42.6332% in the dataset 
    are Neutral/Dissatisfied with the service. 
    Very low in number 5700 of First-time customers were satisfied with the service. And, Returning about 50728 (39.0576%)
    of customers were satisfied with the service.
    Notably, First-time customers show a higher proportion of Neutral/Dissatisfied responses, 
    while Returning customers exhibit a more favorable satisfaction rate.";
RUN;


title c=stb bcolor=whitesmoke Height=12pt "Satisfaction Percentage by Class of Travel";
footnote height=1pt "";
/*Calculating Satisfaction Percentage by Class of Travel*/
options validvarname=any;
PROC FREQ DATA=Passengers;
    TABLES Satisfaction*Class / OUT=class_satisfaction(KEEP=LABEL Class COUNT PERCENT);
RUN;

PROC PRINT DATA=class_satisfaction;
    TITLE 'Satisfaction Percentage by Class of Travel';
    footnote1 height=10pt " It is observed that 18994 cutomers flying Business class and 54458 customers flying Economy are
     Neutral/Dissatisfied with the service.
     And, 43166 Business and 13262 Economy flyers were satisfied with the service of the airline.
     Business class flyers display a higher satisfaction rate (43.17%) compared to Economy class 
     flyers (13.26%). These findings emphasize the need for improvements to enhance customer satisfaction, 
     particularly among First-time customers and Economy class flyers.";
     footnote2 "";
     footnote3 height=10pt "To enhance the overall customer experience, the airline should prioritize addressing the 
     concerns of First-time customers and Economy class flyers. Additionally, it is vital to maintain 
     the high satisfaction levels among Returning customers and Business class flyers, as they currently 
     represent the more satisfied customer segments.";
RUN;

/**************************************************************************************************************/

title1 c=stb bcolor=aliceblue Height=14pt "Which factors contribute to customer satisfaction the most? ";
footnote height=1pt "";

title2 "";

title3 c=stb bcolor=whitesmoke Height=12pt "In-Flight Services";


/* FOR IN-FLIGHT SERVICES
/* Calculating the sum of scores for each factor */
proc means data=Passengers
           sum
           noprint;
  var Cleanliness "Seat Comfort"n "In-flight Service"n "Food and Drink"n "Leg Room Service"n "In-flight Wifi Service"n "In-flight Entertainment"n;
  output out=Sum_Scores_Inflight sum=;
run;

/* Calculating the average score for each factor */
data Avg_Scores_Inflight;
  set Sum_Scores_Inflight;
  array factors(*) Cleanliness "Seat Comfort"n "In-flight Service"n "Food and Drink"n "Leg Room Service"n "In-flight Wifi Service"n "In-flight Entertainment"n;
  do i = 1 to dim(factors);
    factors(i) = factors(i) / 129880; /* Divide the sum by the number of customers (_n_) to get the average */
  end;
  drop i;
run;

/* Creating a dataset to store the average scores for each factor */
data Avg_Scores1;
  input Factor $ Mean_Score;
  datalines;
Cleanliness 3.2863258392
SeatComfort 3.4413612565
InflightService 3.6421927933
FoodAndDrink 3.2047736372
LegRoomService 3.3508777333
WifiService 2.7286957191
Entertainment 3.3580766862
;

/* Creating the bar chart */
proc sgplot data=Avg_Scores1;
  TITLE4 "Average Satisfaction Scores for In-Flight Services";
  footnote height=10pt "We can see from the chart that passengers are not happy with the Inflight Wifi Service.
  The Food and Drink service can also be improved. The Inflight steward service has the highest average score and thus is positively affecting the satisfaction of the customers.";
  vbar Factor / response=Mean_Score /* Using Mean_Score column which contains the average scores */
               datalabel datalabelattrs=(color=black) 
               nooutline /* Removing outline around bars */
               fillattrs=(color=lightblue); /* Customizing bar fill color */
  xaxis display=(nolabel) label="Factors";
  yaxis label="Average Score" min=0 max=5;
  refline 3 / axis=y lineattrs=(color=red thickness=2 pattern=dotted );
run;

/*****************************************/

title1 c=stb bcolor=whitesmoke Height=12pt "Other Airline Services";

/* FOR OTHER SERVICES
/* Calculating the sum of scores for each factor */
proc means data=Passengers
           sum
           noprint;
  var "Ease of Online Booking"n "Check-in Service"n "Online Boarding"n "Gate Location"n "On-board Service"n "Baggage Handling"n;
  output out=Sum_Scores_OTHER sum=;
run;

/* Calculating the average score for each factor */
data Avg_Scores_Other;
  set Sum_Scores_Other;
  array factors(*) "Ease of Online Booking"n "Check-in Service"n "Online Boarding"n "Gate Location"n "On-board Service"n "Baggage Handling"n;
  do i = 1 to dim(factors);
    factors(i) = factors(i) / 129880; 
  end;
  drop i;
run;



/* Creating a dataset to store the average scores for each factor */
data Avg_Scores2;
  input Factor $ Mean_Score;
  datalines;
EaseOnlineBook 2.7568755775
CheckinService 3.3062673237
OnlineBoarding 3.2526331999
GateLocation 2.9769248537
OnBoardService 3.3508777333
BaggageHandling 3.6321142593
;
/* Create the bar chart */
proc sgplot data=Avg_Scores2;
  TITLE2 "Average Satisfaction Scores for Other Services";
  footnote height=10pt "We can infer that lack of Ease of Online booking and outlying Gate Locations
  are critical factors affecting the passenger satisfaction. Meanwhile customers are happy with the Baggage Handling of the airline.";
  vbar Factor / response=Mean_Score /* Using Mean_Score column which contains the average scores */
               datalabel datalabelattrs=(color=black) 
               nooutline /* Remove outline around bars */
               fillattrs=(color=grey); /* Customize bar fill color */
  xaxis display=(nolabel) label="Factors";
  yaxis label="Average Score" min=0 max=5;
  refline 3 / axis=y lineattrs=(color=red thickness=2 pattern=dotted );
run;

/***************************************************/

title1 c=stb bcolor=aliceblue Height=14pt "Is there any underlying relation between Arrival Delay, Departure Delay and Flight Distance ?";
footnote1 height=10pt "In summary, there is no strong linear relationship between Flight Distance and 
either Arrival Delay or Departure Delay. However, there is a very strong positive linear relationship 
between Arrival Delay and Departure Delay, indicating that they are closely related. ";


/* Calculating statistical measures for Flight Distance, Arrival Delay, and Departure Delay */
proc means data=Passengers mean std noprint;
  var "Flight Distance"n "Arrival Delay"n "Departure Delay"n;
  output out=SummaryStats mean= Mean_Std std= Std_Std;
run;

/* Print the summary statistics dataset */
proc print data=SummaryStats;
run;

/*  Calculating the correlation matrix */
proc corr data=Passengers pearson;
  var "Flight Distance"n "Arrival Delay"n "Departure Delay"n;
run;

/*  Creating a scatter plot matrix */
proc sgscatter data=Passengers;
  matrix "Flight Distance"n "Arrival Delay"n "Departure Delay"n;
  TITLE "Scatter Plot";
  footnote "";
run;



/************************************************************************************************************/
/************************************************************************************************************/

title1 c=stb bcolor=lightblue Height=16pt " Data Analysis II ";
footnote height=1pt "";
title2 "";
title3 c=stb bcolor=aliceblue Height=14pt "1. Read the dataset erasmus.csv into SAS and call the resulting table erasmus, saving
 it in the s40840 library. The le contains column names on the rst row, with the rst
 observation starting on the second row. You should ensure your code will overwrite
 any previous object of the same name. ";
footnote height=1pt "";
title5 "";
title6 c=stb bcolor=whitesmoke Height=12pt "a)Print the 1st 4 rows of the resulting erasmus table";
footnote height=1pt "";

/* Importing the dataset */
libname s40840 '/home/u63441807/Course/Final Project';
PROC import out=s40840.erasmus
	replace
	datafile= "/home/u63441807/my_shared_file_links/u49048486/Final_Project/erasmus.csv" DBMS=CSV;
	getnames=yes;
	datarow=2;
run;


PROC PRINT data=s40840.erasmus (obs=4);
RUN;

/**************************************/

title c=stb bcolor=whitesmoke Height=12pt "b)The duration variable is stored in months. Find the mean duration spent in the
 programme by students of Irish nationality (`IE'). How many students of Irish
 nationality are in the dataset?";
footnote height=10pt "As seen, the mean duration spent in programme by 2765 Irish students is around 43 days. ";

PROC MEANS DATA=s40840.erasmus N NOPRINT;
  VAR duration;
  WHERE nationality = 'IE';
  OUTPUT OUT=mean_duration_mean MEAN=mean_duration N=_freq_;
RUN;

DATA mean_duration_mean;
  SET mean_duration_mean;
  LENGTH nationality $2.; 
  nationality = 'IE'; /* Adding a new variable to set the nationality value */
RUN;

PROC PRINT DATA=mean_duration_mean;
  VAR nationality mean_duration _freq_;
RUN;

/******************************************/

title1 c=stb bcolor=whitesmoke Height=12pt "c) One student is older than all other participants. What is the age of this student?
 In what city did this student study? In what academic year did they start?";
footnote height=10pt "The age of the student is 80. The student studied in Valencia. The student's academic year started in 2018.";

/* Sorting the dataset by age in descending order to find the oldest student */
PROC SORT DATA=s40840.erasmus OUT=sorted_erasmus;
  BY descending age;
RUN;

/* Using the first observation in the sorted dataset to get the oldest student's details */
DATA oldest_student;
  SET sorted_erasmus (obs=1);
  age_oldest = age; /* Creating a new variable to store the age of the oldest student */
RUN;

/* Printing the age, city, and academic year of the oldest student */
PROC PRINT DATA=oldest_student;
  VAR age_oldest sending_city academic_year;
  TITLE2 "Oldest Student Details";
RUN;

/**************************************************/

title1 c=stb bcolor=whitesmoke Height=12pt "d) Create a table of the nationality variable for students who are not from Ireland
 (that is, their nationality is not `IE') and whose receiving city is Dublin. The table
 should be ordered from highest to lowest frequency. What is the most frequent
 nationality of non-Irish students who studied in Dublin?";
footnote height=10pt "The most frequent nationality of non-irish students who studied in Dublin are from UK count:37";

PROC FREQ DATA=s40840.erasmus NOPRINT;
  WHERE nationality ne 'IE' AND receiving_city = 'Dublin';
  TABLES nationality / OUT=freq_table (DROP=PERCENT) LIST MISSING;
  /* The OUT=freq_table option stores the frequency table in a new dataset named freq_table */
RUN;

/* Sorting the frequency table in descending order based on frequency */
PROC SORT DATA=freq_table;
  BY descending COUNT;
RUN;

/* Printing the frequency table */
PROC PRINT DATA=freq_table;
  VAR nationality COUNT;
  TITLE2 "Frequency Table of Non-Irish Students Studying in Dublin";
RUN;

/*****************************************************/


title1 c=stb bcolor=whitesmoke Height=12pt "e) In a single table, print the summary statistics for the age variable, divided into
 groups by both gender and academic year. Which cohort had the greatest mean age?";
footnote height=10pt "As observed from the table, Female in academic year 2018-2019 have the greatest mean age -25.021495275";

PROC MEANS DATA=s40840.erasmus NOPRINT;
  VAR age;
  CLASS gender academic_year;
  TYPES gender*academic_year; /* Requesting statistics for each combination of gender and academic year */
  OUTPUT OUT=summary_stats
    MEAN=mean_age;
RUN;

/* Sorting the summary_stats dataset in descending order based on mean age */
PROC SORT DATA=summary_stats;
  BY descending mean_age;
RUN;

/* Printing the summary statistics table */
PROC PRINT DATA=summary_stats;
  VAR gender academic_year mean_age;
  TITLE2 "Summary Statistics for Age by Gender and Academic Year";
RUN;

/***********************************************************/

title1 c=stb bcolor=whitesmoke Height=12pt "f) Produce a clustered bar chart of the `academic year' variable, clustered by gender.
 Describe the resulting plot.";
footnote height=10pt "From the above plot, we can see that there was monumentous increase in
 number of students opting for Erasmus study programme from 2014 to 2016.
 More number of Female students have opted for such programmes than Male students and others over the years. 
 The number of Male students opting for Erasmus programmes has decreased from 2019 to 2020 whereas the count of Female students remains almost the same.";

/* Sorting the dataset by academic year  */
PROC SORT DATA=s40840.erasmus;
  BY academic_year;
RUN;

/* Creating a clustered bar chart */
PROC SGPLOT DATA=s40840.erasmus;
  VBAR academic_year / GROUP=gender GROUPDISPLAY=CLUSTER;
  TITLE2 "Clustered Bar Chart of Academic Year by Gender";
  XAXIS LABEL="Academic Year";
  YAXIS LABEL="Count";
  KEYLEGEND / TITLE="Gender";
RUN;

/********************************************************************************************************/

title1 c=stb bcolor=aliceblue Height=14pt "2. For this question, create a subset of the erasmus dataset which contains only those
 individuals whose receiving country is Ireland (`IE'). Call this subset erasmus2 and
 use this subset for all of the follwing parts";
footnote height=1pt "";
title2 "";

/* Creating the subset erasmus2 with receiving country 'IE' */
DATA erasmus2;
  SET s40840.erasmus;
  WHERE receiving_country = 'IE';
RUN;


title3 c=stb bcolor=whitesmoke Height=12pt "a) Conduct a univariate analysis of the age variable for those individuals in erasmus2.
 Write a short description of your findings, including key statistics and discussion
 of any plots produced.";
footnote height=10pt " The average age of individuals in the dataset is around 24.41 years,
 with the age range spanning from 13 to 69 years. The median age of 20 years suggests that
 half of the individuals are younger than 20, and the other half are older.";
/*  Univariate analysis of the age variable */
proc univariate data=erasmus2 noprint;
  var age;
  output out=age_summary_stats mean=mean_age median=median_age min=min_age max=max_age;
run;

/* Displaying the summary statistics for the age variable */
proc print data=age_summary_stats;
run;

/* Creating a histogram of age distribution */
proc sgplot data=erasmus2;
  histogram age / binwidth=1;
  title "Histogram of Age Distribution for Individuals in erasmus2";
  footnote "As seen from the histogram, since the mean (24.41 years) is greater than the median (20 years),
  the age distribution is right-skewed. In a right-skewed distribution, the tail of the distribution extends
  more to the right, indicating that there are relatively more older individuals with ages farther
  from the mean. In this case, the maximum age (69 years) is causing the rightward tail in the distribution,
  pulling the mean higher than the median.";
  xaxis label="Age";
  yaxis label="Frequency";
run;

/****************************/

title1 c=stb bcolor=whitesmoke Height=12pt "b) Create boxplots of the age variable in erasmus2, grouped by gender. Ensure the
 plot is neat with an appropriate title etc. Comment on the resulting plot.";
footnote height=10pt "From the boxplot we can observe that both Male and Female show a right skewed distribution
 as the mean > median in both cases ( more older students with ages away from the mean). Whereas in Undefined, it is a left skewed distribution. 
 There are many extreme values in Male and Female age groups but none in undefined group.
 Out of the three groups, Female group has broader whisker as it has more students of older age groups comparatively.";

proc sgplot data=erasmus2;
  vbox age / category=gender;
  title2 "Boxplots of Age Variable by Gender";
run;

/******************************/

title1 c=stb bcolor=whitesmoke Height=12pt "c) Conduct a hypothesis test to see if there is a statictically significant difference
 between the mean ages of female and male students, using as your sample data
 those students in erasmus2. State your hypotheses carefully, check all assumptions necessary,
 run your chosen test, comment on the resulting plots and state
 your conclusion clearly. Use a significance level of α = 0.01.";
footnote1 height=10pt "Here is a summary of the key findings:";

footnote2 height=10pt "1. Sample Sizes and Descriptive Statistics:
   - For Female students: The sample size is 1496, with a mean age of 25.0909 years and a standard deviation of 10.6835 years.
   - For Male students: The sample size is 1237, with a mean age of 23.6257 years and a standard deviation of 9.6632 years.";

footnote3 height=10pt "2. Difference in Means (Pooled and Satterthwaite):
   - The difference in mean ages between Female and Male students is approximately 1.4652 years.
   - The standard error of the difference is 0.3933 for the Pooled method and 0.3896 for the Satterthwaite method.";

footnote4 height=10pt "3. Confidence Intervals:
   - For Female students, the 99% confidence interval for the mean age is between 24.3785 and 25.8033 years.
   - For Male students, the 99% confidence interval for the mean age is between 22.9169 and 24.3345 years.
   - The 99% confidence interval for the difference in means (Pooled method) is between 0.4514 and 2.4790 years.";

footnote5 height=10pt "4. T-Test Results:
   - The t-value for the t-test is approximately 3.73 for the Pooled method and 3.76 for the Satterthwaite method.
   - The p-values for both t-tests are very small (less than 0.0002), indicating statistical significance at the α = 0.01 level.";

footnote6 height=10pt "5. Equality of Variances:
   - The test for equality of variances (Folded F-test) indicates that the variances of the age
   distributions for Female and Male students are statistically significantly different (p-value < 0.0002).";

footnote7 "";
footnote8 height=10pt "Conclusion:
Based on the t-test results, we reject the null hypothesis that there is no statistically significant difference between the mean ages of Female and Male students in the `erasmus2` subset. 
The data provide strong evidence to support the alternative hypothesis that there is a significant 
difference in the mean ages of Female and Male students. The confidence intervals for the mean ages of 
each group and the difference between the groups' means further confirm the significance of the findings. 
Additionally, the unequal variances suggest that the groups might have different age distributions.";

/* Selecting only 2 genders and store it in a new dataset */
data s40840.erasmus3;
  set erasmus2;
  where gender IN ('Male' ,'Female'); 
run;

/* Performing hypothesis test with alpha =0.01*/
proc ttest data=s40840.erasmus3 alpha=0.01;
   class gender;
   var age;
run;

/*****************************************************************************************************************/
/*****************************************************************************************************************/

title1 c=stb bcolor=lightblue Height=16pt "Tasks demonstration  ";
footnote height=1pt "";

title2 "";
title3 c=stb bcolor=aliceblue Height=14pt " Statistics Task";
title4 c=stb bcolor=whitesmoke Height=8pt  "The SAS Statistics Task provides a user-friendly interface to perform various 
statistical analyses on data. It offers a range of options to explore data, calculate summary 
statistics, Distribution Analysis, Correlation Analysis, Table Analysis and conduct tests.";
title5 "";

title6 c=stb bcolor=whitesmoke Height=12pt "1. Summary Statistics";
footnote1 height=10pt "Summary statistics are a fundamental aspect of data analysis, providing valuable 
insights into the distribution and characteristics of numerical variables. In this demonstration, 
we calculate summary statistics for the Width in the SASHELP.FISH dataset.";
footnote2 height=10pt "The output displays the summary statistics for the selected numerical variable
 in the SASHELP.FISH dataset. The computed statistics include the mean, standard deviation, minimum,
 maximum, and quartiles for each variable.";

/* Summary Statistics Demonstration */
PROC MEANS DATA=SASHELP.FISH NOPRINT;
  VAR Width;
  OUTPUT OUT=SummaryStats MEAN= Mean_Std MIN= Min_Std MAX= Max_Std P25= P25_Std P50= P50_Std P75= P75_Std;
RUN;

PROC PRINT DATA=SummaryStats;
  TITLE7 "Summary Statistics for Width";
RUN;


/*********************/

/* For T-Test */
title c=stb bcolor=whitesmoke Height=12pt "2. T-Test";
footnote1 height=10pt "The t-test output provides the results of the two-sample t-test between the
 Weight variable for the Bream and Parkki species. The t-test results include the means and standard
 deviations of both groups, the t-value, degrees of freedom, and p-value.In conclusion,
 the t-test results indicate a statistically significant difference in the mean weights of 
 Bream and Parkki fish species. The species Bream tends to have a significantly higher mean 
 weight compared to Parkki.";
footnote2 "";
 
footnote3 height=11pt "The SAS Statistics Task is a valuable tool that simplifies statistical analysis 
by providing a user-friendly interface. In this report, we demonstrated how to use the Statistics 
Task to compute summary statistics and conduct a t-test using the SASHELP.FISH dataset.";
footnote4 ""; 
footnote5 height=11pt "The task's functionality allows users to explore and analyze data efficiently, gaining valuable insights into their 
datasets and making informed decisions based on statistical findings.";
footnote6 "";
footnote7 height=11pt "The SAS Statistics Task's capabilities extend far beyond the examples 
presented in this report, making it a versatile tool for various statistical analyses. Users can 
leverage its power to perform Distribution Analysis, Correlation Analysis, Table Analysis, 
create informative visualizations, and gain deeper insights into their data."; 
footnote8 "";
footnote9 height=11pt "By harnessing the capabilities of the SAS Statistics Task, analysts and
 researchers can make data-driven decisions with confidence.";


* Two-Sample T-Test between "Bream" and "Parkki";
PROC TTEST DATA=SASHELP.FISH(where=(Species in ('Bream', 'Parkki')));
  CLASS Species;
  VAR Weight;
RUN;

