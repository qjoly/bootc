# Boot Container

This repository provides a containerized environment for building a bootable ISO image for my Desktop machine. It uses [`bootc`](https://bootc-dev.github.io/bootc//) as the core tool for this process.

In the past, I have used various method to achieve similar results (such as Packer controlling a full deployment pipeline to build custom images), but BootC offers a more streamlined and efficient approach.

## What is BootC / Bootable Container?

BootC is a tool that simplifies the process of creating bootable container images. It provides a set of commands and configurations to streamline the building, testing, and deployment of these images, making it easier for developers to work with containerized environments.

In a nutshell, with BootC, you can quickly create a full bootable artefact that can be used in various scenarios, such as virtual machine deployments, bare-metal installations, or cloud-based environments... everything with only a **Containerfile** (strictly equivalent to a Dockerfile).

![Bootable Container](https://docs.fedoraproject.org/en-US/bootc/_images/bootable-container.png)

By implementing a well-defined **Containerfile**, you can ensure that your bootable container image is built consistently and reliably, regardless of the underlying infrastructure.

## OSTree

Even if OSTree and BootC are not linked directly, they complement each other and share significant underlying code. OSTree is a powerful tool for managing and deploying filesystem trees, making it an ideal choice for creating immutable and versioned layers of filesystem images.

Each time your upgrade or install packages, it will generate a new version of the filesystem tree, allowing you to easily roll back to a previous state if needed.

![alt text](img/ostree.png)

This behavior is quite similar as `git`, where each commit creates a new version of the codebase, allowing you to easily revert to a previous state if needed or `nix` where each build generates a new version of the package.

## Build-time vs Run-time

Inside the `Containerfile`, you'll see that I only use `dnf` during the build-time to install the necessary packages and dependencies. This is because at this time of the workflow, the image is being constructed and **is still mutable**.

At runtime (Once the OS is deployed), it becomes immutable and the user has to use `rpm-ostree` (the fedora implementation of OSTree) to manage and update the filesystem.
