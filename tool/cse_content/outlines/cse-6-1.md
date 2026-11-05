# Course: Machine Learning  (level id "deep-cse-6-1", lesson ids "deep-cse-6-1-01".."-26")
Builds on Linear Algebra (deep-cse-2-5: vectors, dot product, matrices, eigenvalues, lesson 25 PCA preview), Probability & Statistics
(deep-cse-2-6: mean/variance, Bayes' theorem, lesson 24 least squares line and R squared), Calculus (deep-cse-1-4: derivatives) and
Artificial Intelligence (deep-cse-5-1: lesson 22 naive Bayes spam filter, lesson 24 ML overview, perceptron, decision tree idea).
Those are only recapped. Later courses go deeper and are only pointed to: Pattern Recognition (cse-6-12), Data Science (cse-6-14),
Data Mining (cse-7-6, clustering and association rules in depth), Neural Networks & Fuzzy Systems (cse-7-8), Deep Learning (cse-8-1),
Reinforcement Learning (cse-8-4). Tools are described as concepts (Python, NumPy, pandas, scikit-learn), no version claims.
01 What machine learning is: rules vs learning from data, Mitchell's T/P/E definition, model and parameters, supervised (classification, regression), unsupervised, reinforcement, semi/self-supervised briefly, ML in Bangladesh, course map
02 The ML workflow: framing the problem, collecting data, exploring, preparing features, choosing a baseline, training, evaluating, deploying, monitoring; worked baseline example; iteration
03 Data and features: rows, columns, features, labels, data types, cleaning (missing values with mean/median worked, duplicates, outliers), encoding (label vs one-hot worked), scaling (min-max and standardization worked), feature engineering
04 Splitting data: generalization, train/validation/test, 70/15/15 worked, random vs stratified vs time-based split, data leakage examples, fit preprocessing on train only
05 Linear regression and least squares: hypothesis y = w x + b, residuals, sum of squared errors, slope and intercept formulas worked on flat rent data, prediction, R squared, multiple regression and the normal equation idea
06 Gradient descent: cost surface, slope as direction, update rule, worked steps on y = w x, learning rate too small/good/too big worked, batch vs stochastic vs mini-batch, stopping, why scaling helps
07 Loss functions: loss vs cost vs metric, MSE, MAE, Huber worked with an outlier, 0-1 loss, log loss preview, hinge preview, choosing a loss for the problem
08 Polynomial regression and over/underfitting: adding x squared features, degree 1/2/3 fitted to four points worked, training vs validation error, learning curves, how to detect each problem
09 Bias and variance: dartboard picture, bias squared + variance + noise, worked example with four training sets, complexity curve, remedies for high bias vs high variance
10 Regularization: penalizing large weights, L2 ridge (one-weight worked with lambda), L1 lasso and sparsity, elastic net, choosing lambda, scaling first, early stopping and other regularizers
11 Logistic regression: why not linear regression for classes, sigmoid values worked, probability and threshold, decision boundary worked, log loss worked, gradient step worked, softmax for many classes briefly
12 Evaluating classifiers: confusion matrix, accuracy, precision, recall, F1, specificity worked, threshold trade-off, ROC curve points worked, AUC by pair counting, macro vs micro averages briefly
13 Cross-validation and hyperparameter tuning: parameters vs hyperparameters, k-fold worked (mean and spread), stratified and time-series CV, leave-one-out, grid vs random search with counting worked, nested CV idea, pipelines
14 Imbalanced data: accuracy paradox worked, better metrics (precision-recall, PR-AUC), undersampling, oversampling, SMOTE worked, class weights worked, threshold moving, collecting more minority data
15 k-nearest neighbours: lazy learning, Euclidean and Manhattan distances worked, voting and choosing k, ties, distance weighting, why scaling matters worked, k-NN regression, cost and the curse of dimensionality
16 Naive Bayes and probabilistic classifiers: Bayes' rule recap, naive independence, worked spam example, zero-probability problem and Laplace smoothing worked, log probabilities, Gaussian NB idea, generative vs discriminative
17 Decision trees: structure, entropy and information gain worked, Gini impurity worked, CART, numeric thresholds, stopping rules, pruning, regression trees, strengths and weaknesses
18 Ensemble methods: wisdom of crowds with majority vote worked, bootstrap sampling (63.2 percent worked), bagging, random forest and feature subsets, out-of-bag error, boosting idea, AdaBoost weight update worked, gradient boosting idea, stacking briefly
19 Support vector machines: separating hyperplane, margin and support vectors, distance to the plane worked, margin 2/||w||, hard vs soft margin and C, kernel trick idea, polynomial kernel worked, RBF kernel, when to use
20 Neural networks introduction: neuron recap, activation functions (sigmoid, ReLU), layers, forward pass worked on a 2-2-1 network, loss, backpropagation idea with one gradient worked, parameter counting; points to cse-7-8 and cse-8-1
21 K-means clustering: unsupervised grouping, algorithm steps, full worked iteration on six points, inertia (SSE), choosing k (elbow, silhouette idea), k-means++ idea, limitations
22 Hierarchical and density clustering: agglomerative vs divisive, single/complete/average linkage worked on 1D points, dendrogram and cutting it, DBSCAN idea (eps, minPts, noise); points to cse-7-6
23 Dimensionality reduction and PCA: curse of dimensionality, feature selection vs extraction, PCA steps, worked 2D example (covariance, eigenvalues, explained variance, projection), choosing components, t-SNE/UMAP named only
24 The practical toolkit and ML in production: Python, NumPy arrays and vectorization, pandas DataFrames, scikit-learn fit/predict/transform and pipelines as concepts, notebooks, saving a model, batch vs online serving, monitoring, data drift, retraining, versioning
25 Fairness, bias, privacy and responsible ML: where bias comes from, unequal error rates worked, fairness definitions in plain words, explainability, privacy and anonymisation limits, consent, security of models, documentation, Bangladesh context
26 Capstone: predicting Boro rice yield for an invented district dataset, full workflow worked (framing, cleaning with median imputation, split, mean baseline MAE, one- and two-feature linear models, comparing test MAE), honest limits, ethics check, course recap and what next
