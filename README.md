# Titanic_Assignment
Titanic: Machine Learning from Disaster 

INTRODUCTION:
The sinking of the RMS Titanic is one of the most infamous shipwrecks in
history. On April 15, 1912, during her maiden voyage, the Titanic sank after
colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This
sensational tragedy shocked the international community and led to better safety
regulations for ships.

One of the reasons that the shipwreck led to such loss of life was that there were
not enough lifeboats for the passengers and crew. Although there was some
element of luck involved in surviving the sinking, some groups of people were
more likely to survive than others, such as women, children, and the upper-class.

In this study, we intend to perform a statistical analysis of the fatalities on the ship
using the Titanic dataset. The main question that we are addressing here is
whether there is a statistically significance relation between the death of the
person and their passenger class, age, sex and/or port where they embarked their
journey and also to predict the people who survived or not.

References to the Literature
 Wikipedia: RMS Titanic
 Wikipedia: Passengers of RMS Titanic
The data set is collected from Kaggle.

Variables:
No of records in train dataset:891
No of records in test dataset:418

1.Survived: Survived Column indicates whether the person survived or not 0-dead 1-survived

2.P Class:PClass Column indicates what class the passgenger was travelling Passenger Class: 1st,
2nd, 3rd

3.Name:This column name of the passenger.It comes with titles like Mr,Dr which will help us
group the people.

4.Sex: Sex indicates the sex of the passenger (M/F)

5.Age:Age indicates the age of the person.Totally there is 99 unique ages recorded.

6.SibSp:It Indicates Number of siblings/spouses aboard

7.Parch:It indicates Number of parents/children aboard

8.Ticket Number:It gives the info on the ticket will help us to group families

9.Fare:It gives the info on the ticket fare

10.Cabin:It gives info on which cabin the passanger was staying

11.Embarked: Place where the passenger embarked their journey. One of Cherbourg,
Queenstown or SouthamptonData Organization

The Titanic dataset consists of twelve variables: Passenger ID, Survived, Passenger
Class, Name, Sex, Age, Number of Siblings/Spouse(s) On Board, Number of
Parents/Child(ren) On Board, Ticket Information, Fare, Cabin, and Port or
Embarkment.

For the purposes of this study, we work with only four input variables and one
response variable. As mentioned above, the four input variables are Passenger
Class, Sex, Age, and Port of Embarkment. The response variable is whether they
survived or not.
