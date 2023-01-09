# Sydtest large diffs example

This example illustrates an issue with Sydtest. It purposefully generates test failures where the diffs between actual and expected outputs are large. The issue is that generating these diffs is very slow, which is a usability issue for Sydtest.

**Steps to reproduce:**

Run `nix flake check`.

**Expected behavior:**

The test suite quickly outputs a result.

**Actual behavior:**

The test suite takes a long time to output a result and consumes a lot of memory.

**Notes**

One can verify that the slowness is in the diffing by reducing the replication factors in `test/Spec/LargeDiffsSpec.hs`. Increasing the replication factors by a factor of two or more results in outrageous memory usage and runtime.
