# Git-Hub-Page
Projects Performed in the MSBA Program
Simulated Annealing as Traveling Sales Problem 
Algorithm simulate annealing is
        Initialize parameters: set initial temperature and end temperature
  1:  t                       set initial temperature     
  2:  n                      number of cities 
  3:  d                      distance between all the pair 
 
       Update_T
       Generate_InitialSolution() 
  4:  x                       some initial candidate solution                                                   
  5:  Best                 x
  6:  c                       0                                                P
                                                                                                                                      No

                                                                                   
                                                              Yes                        



                                                                                                                                                    


                                                                                                                            
                                                                Yes








Genetic Algorithm as Travel Salesman Algorithm
Algorithm genetic algorithm is
	Initialize parameters:
  1:  popsize            desired population size   
  2:  g                        gene (x,y coordinates) 
  3:  c                        a single  route satisfying the conditions above
  4:  p                        parents                                                   
  5:  mp                    Mating pool
  6:  poprank           fitness
  7:  m                      mutation
  8:  e                       elitism

       Create_population    
  9:   popsize           [ ]
10:   	for I in range(0, popsize):
11:         population.append(createRoute(cList)) 
12:         return population
       Determine_fitness
13:    fitnessResults           [ ]
14:        for i in range(0, len(population)):
15:        fitnessRessults[i]          Fitness(population[i]).routeFitness()
16:        return sorted 
        Select_mating_pool
17:   selectionResults             [ ]
18:        for i in range (0, e):
19:        selectionResults.append(popRank[i][0])
20:        for i in range(0, len(popRank) – e.Size):
21:        pick          100*random.random()
22:        selectionResults.append(popRank[i][0])
23:       return selectionResult  
        Create_Mattingpool  
        Breed_and_mutate
24.    child          [ ]
25.    childP1         [ ]
26.    childP2          [ ]
27:        for I in range(startGene, endGene):
28:        childP1.append(parent1[i])
29:        childP2          [item for item in parent2 if item not in childP1]
30:        child = childP1 + childP2
31:       return child
        Next_Generation
32:  repeat
33:         poprank             rankrouts((currentGen)
34:         selectionResults            selection(poprank, elitesize)
35:         mattingpool            matingpool(currentGen, selectionResults)
36:         children            breedPopulation(matingpool, eliteSize)
37:         nextGeneration          mutatePopulation(children, mutationRate)
38:  return nextGeneration







 


 
        


 










 
                                                                                                                     No






                                                                      Yes




                                         
