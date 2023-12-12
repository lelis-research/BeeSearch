# Bee Search

Sample Code for Paper: Program Synthesis with Best-First Bottom-Up Search (https://www.jair.org/index.php/jair/article/view/14394).

This repo contains sample code for Bee Search algorithm for solving SyGuS string manipulation tasks in a post-evalution setting. This code uses neural network from [Bustle](https://arxiv.org/abs/2007.14381), which was trained with our own implementation because Bustle's implementation wasn't available at the time. This code was not used for the experiments in the paper, but it is a good starting point for implementing Bee Search. We are releasing this code to help the community get started with Bee Search. We are working on releasing the code used for the experiments in the paper.

## Dependencies

You will need Python3, Numpy, and Tensorflow installed in your machine to run the starter code.

## Sample Usage

`bee.py` contains code for bee-search. It works with following signature and creates a log file named `bee-search.log`. 

```sh
# Go to src dir
python3 bee.py 57 0
# Generic syntax: bee.py [TaskID] [Easy|Hard]
```

Here, `0 = easy, 1 = hard`. `TaskID` is the SyGuS task number, all tasks names are listed in `config/sygus_string_benchmarks.txt` and actual tasks are in `sygus_string_tasks/`

Running a task will create a log file in logs folder named `bee-search.log`. For the above mentioned task it will have logs like:

```
...
[Task: 56] Benchmark: exceljet1.sl
[Task: 56] Result: Success
[Task: 56] Program: _arg_1.Substr((_arg_1.IndexOf("_") + 1),_arg_1.Length())
[Task: 56] Number of evaluations: 20705
[Task: 56] 2023-02-13 15:44:44.304960
[Task: 56] Time taken: 0:00:02.525268
...
```

We also included the code for code for Bottom-Up Search (BUS) in `bus.py`. It can be run in similar fashion as BeeSearch and creates a log file named `bus.log`.

## Description of Code

The function `search` of the Bee Search algorithm (see `bee.py`), which is invoked in the `synthesize` function, after initializing the grammar used with the trained neural model we provide with the implementation.

The signature of the search method is as follows.
```python
def search(self, bound, string_literals_list, integer_literals_list,
               boolean_literals, string_variables_list,
               integer_variables_list):
```

The parameter `bound` specifies the number of different costs of programs Bee Search will consider during synthesis. This value is used as a proxy for the time limit of the synthesis: smaller values of `bound` will make the search terminate faster and possibly not find a solution for the problem (if the solution cost is larger than the `bound`). If the `bound` value is “large enough,” which is the case in the starter code as it is set to infinite, then the search will run until a solution is found (or your computer runs out of memory!).

The other input parameters specify the language that should be used in search (i.e., which symbols the search will consider while attempting to find a solution to a problem). The method `search` return a solution program (it can return `None` if it doesn’t find one), the number of programs evaluated in search, and the number of times function `heapify_pqs` was called.

The starter code also contains an implementation for the list of programs we will keep in memory, see class `ProgramList`. This class stores all programs encountered in search and allows for an efficient evaluation of the programs with the neural network (it accumulates all programs generated with a given cost and evaluates all programs in a single batch with the neural model). `ProgramList` has a method called `init_plist` that needs to be called before starting the search. This method initializes the list of programs with the smallest programs possible. This method also initializes the search in the cost-tuple space. It is invoked using `init_plist` in the implementation of `search` procedure.

In the starter code, `ProgramList` stores one priority queue for each arity of operator in the language. For example, if the language is of the form S → replace(S,S,S) | concat(S,S), then `ProgramList` stores two priority queues, one for cost tuples with arity 3 (for the “replace” operator) and one for cost tuples with arity 2 (for the “concat” operator). Bee Search can also use a single priority queue for all arities; either strategy for implementing the algorithm is fine.

After initializing the list of programs, search perform a number of iterations that is bounded by the value of `bound`. In each iteration, it gets the list of operations of the language that should be expanded next (i.e., all the cost tuples with cheapest cost). This list of cost tuples can be obtained with the method `get_next_cheapest` of the instance of the `ProgramList` class Bee Search uses. This method receives no parameters and returns a tuple of the form `(list, cost)`, where `list` contains all arities whose cheapest cost-tuple (the cost tuple at the top of its priority queue) has the cheapest value; `cost` stores this cheapest value.

Once the values of `list` and cost are obtained from `get_next_cheapest`, `search` can call the `grow` method, which is implemented as an iterator, to obtain the next batch of programs with cost `cost`:

```python
for p in self.grow(list, cost):
    # check whether p is a solution to the problem
    ...
```

For verifying whether a program is correct we can use the method `is_correct` from the Bee Search class. Once the for loop of the grow method is finished, `search` needs to expand the next cost-tuple states for all priority queues whose cheapest cost-tuple state had a cost of `cost`. This is achieved by calling the method `generate_next_set_of_combinations` of class `ProgramList`.

As describe in sample usage, you can test the code on problem 57 to verify that it is working correctly. The following command should return a solution to the problem:

```sh   
python bee.py 57 0
```

The number 0 indicates the “easy” version of the problem 57. If you change from 0 to 1, the search will be performed with a much larger DSL, which normally results in a much more difficult synthesis problem. All experiments will be performed on the easier version of the problems, but you are welcome to try the harder version of them too. If all goes well, Bee Search should solve problem 57 in a few seconds and information about the solution will be added to the log file `bee-search.log`.

## Description of Other Folders

### src

It is the source code directory and contains all the source code in python for running bee-search with Wu cost fn.

### models

Contains pre-trained models

### config

It contains the benchmark and properties configuration


## Reference

```bibtex
@article{Ameen_2023,
   title={Program Synthesis with Best-First Bottom-Up Search},
   volume={77},
   ISSN={1076-9757},
   url={http://dx.doi.org/10.1613/jair.1.14394},
   DOI={10.1613/jair.1.14394},
   journal={Journal of Artificial Intelligence Research},
   publisher={AI Access Foundation},
   author={Ameen, Saqib and Lelis, Levi H.S.},
   year={2023},
   month=aug, pages={1275–1310} }
```
