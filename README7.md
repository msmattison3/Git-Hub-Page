# Decsision Tree and Code - R Studio

---
title: "BUAD5032 Assignment 3 Group 19"
author: "Scott Mundy, David Tabert, Arcelio Perez, Nicole Mattison"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
# Decision Tree
![](./HBRdecisiontree.PNG)
# Alternative 1 and 2
	For the first alternative, 155,000 per month for 24 months, we came to an EMV of 360,000. We calculated this by multiplying 155,000 by 24, and then subtracting the cost of labor given in the problem. The cost of labor was 3,360,000 which is 140 per hour multiplied by 1000 hours per month over 24 months.


	The second alternative required slightly more math, due to the possibility of a bonus. First, we multiplied 125,000 by 24, and added the 1.5 million bonus, subtracted the cost of labor, which gave us 1,140,000. Next, we multiplied 125,000 by 24 again, but did not include the 1.5 million bonus, which ends up being -360,000 (since we pay more per month than we make) After collapsing the tree backwards, taking into account the 0.7 probability of getting the bonus, our final EMV for the second alternative was 690,000. 

Code for Alternative 1 and 2
```{r}
bo <-1500000.00 #bonus 
hours <- 1000.00 #hours per month
pphour <- 140.00 #price per hour
period <- 24 #number of months
costlabor <- hours*pphour*period 
bonus_month <- 125000.00 #monthly payments with bonus 
no_bonus_month <- 125000.00 #monthly payments w/out bonus 
bonus_total <- bonus_month*period #total payment bonus option
bonus_total_w_bonus <- bonus_total + bo #total payment including bonus
no_bonus_total <- no_bonus_month*period #total payment no bonus option 
netbonus <- bonus_total_w_bonus - costlabor #bonus option - cost of labor
netno <- no_bonus_total - costlabor #no bonus option - cost of labor 
#Calculating EMVs 
prob1 <- 0.7 #probability of getting the bonus
prob1b <- 0.3 #probability of not getting the bonus
EMV1 <- ((prob1*netbonus)+(prob1b*netno)) #Overall EMV of alternative 1 
#Alternative 2
alt2 <- 155000 #second offer 
alt2mo <- alt2*period #total second offer 
netalt2 <- alt2mo-costlabor #total second offer - cost of labor 
#EMV 
EMV2 <- netalt2 #EMV of second alternative 
```

# Alternative 3, Make a bid on the RFP (Triangular Probability distribution)
In order to calculate the expected monetary value of the triangular 
probability distribution, we used simple integration to find the area under the curve. 
The curve in our case is simply the slope intercept equation for the line: $mx +b$
In order to calculate the slope and intercept we needed the height
of the most likely value (x = 5.6 million), which, for a triangular distribution, is defined as:
$\frac{2}{b-a}$
Where b is the highest value of the distribution and a is the lowest.
For this distribution,it comes out to about 0.208.
Since the distribution is formed by two lines, it has two slopes and 
two y intercepts, which we calculated using basic algebra.

Afterwards, we simply need to perform a trivial integration to find
the analytical form.
$\int mx + b$ 
Which evaluates to: 
$\frac{1}{2}mx^2 + bx$ 
We then wrote a simple function ("integral()" shown at the bottom) with this equation hardcoded in,
and used that to find the integral between the bounds we wanted.

This gave us the exact probability that the savings contribution from the project would land in each of the four possible categories.
These were 0.0278, 0.3032, 0.3356, 0.3333 for the regions: $<$ 4 million, 4-6 million, 6-8 million and $>$ 8 million savings respectively.

The EMV of the first category, where savings are less than 4 million is simple to calculate because it has no gain sharing.
In the case of the other three regions, with 20\%, 40\% and 60\% gain sharing over certain amounts, we need a point estimate to calculate the contribution of gain sharing. To do this we used the average value theorem of calculus:
$\frac{1}{b-a}\int_{a}^{b} f(x)$
Which tells us the average area under the curve of a function, (f(x)), between the bounds a and b.
However, since we need a point estimate for the x value rather than the integral we needed to determine at what x value we would get this most probable value within the bounds. To do this we used a simple brute force method to find what x, to within 0.01, yields the correct area when integrated using the "best_match()" function shown at the bottom.

For the region of savings between 4 and 6 million, the point of average probability was 5.23 million.
For the region between 6 and 8 million, it was 6.91 million.
And for the region between 8 and 12.8 million it was 8.53 million.

In all cases, the contract paid 150,000 per month for 24 months, with 140,000 per month cost in labor, yielding 240,000.
The EMV for the region $<$ 4 million with no gain sharing is just this 240,000.

For the others, the EMV was 240,000 + the gain sharing obtained from using our point estimates.

The EMV of the 4-6 region was 486,000.
The EMV of the 6-8 region was 1,004,000.
And the EMV of the $>$ 8 region was 1,758,000.

After multiplying these EMVs by their probabilities, summing them and then multiplying by the probability of winning the bid (0.45) the EMV of making a bid is 486,664.583.

Our other code:
```{r}
# triangular distribution
rm(list=ls())
low = 3.2
mid = 5.6
high = 12.8
# The maximum height of a triangular probability distribution is 2/(high-low)
height = 2/(high-low)
# we need slope intercept form
# slope is (y2-y1 / x2-x1) in this case y1 = 0
slope1 = (height)/ (mid-low)
# we know the intercept is -b = m(3.2) 
intspt1 = -1 * slope1*low
slope2 = (-height) / (high-mid)
intspt2 = -1 * slope2 * high
# So now we just need calculus where the integral of mx+b = 1/2 m x^2 + bx
integral <- function(lower_bound, upper_bound, slope, intercept){
  b <-  (0.5 * slope * upper_bound^2) + (upper_bound*intercept)
  a <-  (0.5 * slope * lower_bound^2) + (lower_bound * intercept)

  return(b-a)
}
# First bound prob
prob_lt_4mil = integral(3.2, 4, slope1, intspt1)
# second bound needs two integrals since the slope changes
prob_4_to_6 <- integral(4, 5.6, slope1, intspt1) + integral(5.6, 6, slope2, intspt2)
prob_6_to_8 <- integral(6, 8, slope2, intspt2)
prob_gt_8 <- integral(8,12.8,slope2, intspt2)
# The average value theorem tells us that the average value of an integral is the integral
# times (1/(b-a))
avg_lt_4 = 1/(4-3.2) * prob_lt_4mil
avg_4_to_6 <- 0.5 * prob_4_to_6
avg_6_to_8 <- 0.5 * prob_6_to_8
avg_gt_8 <- 1/(12.8-8) * prob_gt_8
# Rather than try to reverse engineer the x value for the integral we're just using brute 
# force to get a good enough estimate
best_match <- function(lower, upper, slope, intercept, avg_int){
  # reverse integral
  rev_int <- c()
  index <- c()
  for( i in seq(lower,upper,0.01)){
    rev_int <- c(rev_int, abs( avg_int - integral(lower,i,slope,intercept)))
    index <- c(index, i)
  }
  avg_val <- 0.1
  min_val <- min(rev_int)

  for(i in 1:length(rev_int)){
    if( rev_int[i] == min_val){
      avg_val <- index[i]
    }
  }
  return(avg_val)
}
# In this case, rather than deal with the split slope, we just know that the value of the integral
# from 4 to 5.6 is 0.222 which is too high to begin with, so there's no reason to make a special case.
avg_val_4_6 <- best_match(4,5.6,slope1,intspt1,avg_4_to_6)
avg_val_6_8 <- best_match(6,8,slope2,intspt2,avg_6_to_8)
avg_val_gt_8 <- best_match(8,12.8,slope2,intspt2,avg_gt_8)
# EMV calculation, the avg value is multiplied by 1 million to get it into the right units
# < 4 million has no gain sharing
# the static value holds true regardless of gain sharing
static_value = 24 * (150-140) *1000
EMV_lt_4 <- static_value
EMV_4_6 = static_value + 0.2* (avg_val_4_6 - 4)* 1E6
EMV_6_8 <- static_value + 4E5 + 0.4 *(avg_val_6_8 - 6) * 1E6
EMV_gt_8 <- static_value + 1.2E6 + 0.6 * (avg_val_gt_8 - 8) * 1E6
EMV_alt_three <- (EMV_lt_4 * prob_lt_4mil + EMV_4_6 * prob_4_to_6 + EMV_6_8 * prob_6_to_8
                  + EMV_gt_8 * prob_gt_8)
# We still need to account for the probability of getting the bid
EMV_alt_three <- EMV_alt_three * 0.45
```
# Disscussion
If we were to naively pick options based solely on the EMV, then Alternative 2, the 125,000 a month with a 70% chance of a 1.5 million bonus would be the clear winner. Alternative 2 with an EMV of 690,000 is almost 50% higher than the next best option, i.e. Alternative 3 with its EMV of 486,000.
However, if we take into account risk, Alternative 2 is actually the worst option of the three. Alternative 1 is risk free, you are guaranteed a payout of 360,000 no matter what. On the other hand, while there is only a 45% chance that the firm will win the bid for the RFP and actually earn money in Alternative 3, in the event that the bid is lost the EMV is simply zero. We simply won't do the project at all in that case and as such we don't lose anything other than opportunity.

In contrast, Alternative 2 has a 70% chance to pay out a very respectable 1,140,000, but is the only option where we can actually lose money. There is a 30% chance that our firm will end up spending 2 years of work and wages only to end up losing 360,000 in the event we do not earn the bonus. 
This is to say that Alternative 2 has roughly a 1 in 3 chance of catastrophic failure which would seriously damage our firm. As a result our group feels that despite the lower EMV, Alternative 3 is actually the best choice.

This is because, presumably our firm isn't so risk averse that we would pick the totally safe option, and will be willing to gamble for a higher payout. However, in the event of a successful gamble, the EMV for getting the bonus is 1,140,000 while the EMV for winning the bid is 1,077,000, which isn't a massive difference. Of course we are around 56% more likley to win the gamble in Alternative 2 than in Alternative 3 (0.7/0.45 = 1.56). Having said that, it's a gamble either way, and while we are more likely to win the gamble in Alternative 2, it is a "safe" gamble in the case of Alternative 3, meaning that we can walk away from it no worse for wear.
