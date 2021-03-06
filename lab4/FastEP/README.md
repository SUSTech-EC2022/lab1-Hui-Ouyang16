# fastEP

This project is a reproduced work of the paper [Evolutionary Programming Made Faster](https://ieeexplore.ieee.org/document/771163/). 

This paper should be cited if code from this project is used in any way:

```
@article{yao1999evolutionary,
  title={Evolutionary programming made faster},
  author={Yao, Xin and Liu, Yong and Lin, Guangming},
  journal={IEEE Transactions on Evolutionary computation},
  volume={3},
  number={2},
  pages={82--102},
  year={1999},
  publisher={IEEE}
}
```

This project is used for teaching the course **CS408/CSE5012: Evolutionary Computation and Its Applications** at the Southern University of Science and Technology (SUSTech), Shenzhen, China.

*Not 100% sure that it is bug-free. Use at your own risk!*

## Some Details

- Classic Evolutionary Programming (CEP) uses a Gaussian and Fast Evolutionary Programming (FEP) uses a Cauchy distribution for mutation.
- Set values to bounds for points which are out of bounds.
- A fixed lower bound is set for step-size.
- The individual is mutated first then mutate the step-size.

The programs will also output formatted Latex table for results and plots of evolutionary curves.


## Lab 4: Explore how search operators and implementation details affect an EA’s performance.

### Task
- We have seen how the performance of an EA changes when using a Cauchy, instead of Gaussian, to sample random perturbation to generate offspring.
- There are many details which affect an EA's performance:
  - Distributions used to sample random perturbation to generate offspring (cf. pages 8-10, 37 of the slides for Lecture 4)
  - Techniques for handle points out of bounds
  - Set a fix / an adaptive lower bound for $\eta$ or not (cf. pages 39-40 of the slides for Lecture 4)
  - Mutate $\x$ first or mutate $\eta$ first  (cf. Eqs. (2) and (3) on page 9 of the slides for Lecture 4)
  - Mix search biases by self-adaptation (cf. pages 34-36 of the slides for Lecture 4)
  
  (More details can be found in the slides for Lecture 4!)

In this lab, we will exxplore how **search operators** and **implementation details** affect an EA's performance.

