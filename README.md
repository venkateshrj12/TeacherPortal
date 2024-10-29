# Teacher Portal

## Overview
The Teacher Portal is a web application designed for school administration. It allows a principal to create teacher accounts and enables teachers to create and manage student records. The application comes with seed data for the principal and sample teacher accounts for testing.

## Project Status
This project is currently completed and ready for use.

## Requirements
- Ruby (ruby-3.1.2)
- Rails (Rails 7.1.4.2)
- sqlite3 (3.45.0)

## Installation
1. Clone the repository:  
   ```bash
   git clone 'https://github.com/venkateshrj12/TeacherPortal.git' && cd TeacherPortal
   ```
2. Install dependencies (ensure you have Bundler installed):  
   ```bash
   gem install bundler && bundle install
   ```
3. Set up the database (create and migrate):  
   ```bash
   rails db:create && rails db:migrate
   ```
4. Seed the database (populate with the principal and teacher accounts):  
   ```bash
   rails db:seed
   ```

## Running the Application
Start the Rails server:  
```bash
rails server
```  
Navigate to Postman and import the collection JSON file from the repository. You can do this by going to the Collections tab, clicking on the Import button, and selecting the downloaded collection file.

This revision provides a little more detail about how to perform the import action, making it easier for users who may not be familiar with the Postman interface.

If you want to include specific steps, you could break it down further:

* Open Postman.
* Click on the Collections tab on the left sidebar.
* Click the Import button.
* Choose the Upload Files option and select the collection JSON file you downloaded from the repository.
* Click Import.


## Usage
- The principal can create new teacher accounts.
- Teachers can create and manage student records.

## Testing
To run tests, use:  
```bash
rspec
```