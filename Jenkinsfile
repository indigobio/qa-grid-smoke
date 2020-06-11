#!/usr/bin/env groovy

def testsCommand() {

    def foo = "{ 'goog:chromeOptions' => {'args' => [ '--no-sandbox', '--headless' ] } }"
    def retStr = "GRID_SELENIUM=${params.GRID_URL} BROWSER_OPTIONS=${foo} bundle exec cucumber"
    return retStr
}

pipeline {

    parameters {
        string(name: 'GIT_BRANCH', description: '', defaultValue: 'master' )
        string(name: 'GRID_URL', description: 'address of remote grid', defaultValue: 'http://selenium-hub.ci.indigo:4444/wd/hub' )
        string(name: 'CHROME_BROWSER_OPTS', description: 'chrome browser options.', defaultValue: '' )
        string(name: 'FIREFOX_BROWSER_OPTS', description: 'firefox browser options.', defaultValue: '' )

        booleanParam(
                name: 'RELOAD_JOB_DEFINITION',
                defaultValue: false,
                description: 'Redefine this jenkins job according to the ' +
                        'Jenkinsfile found in the given branch and stop. This ' +
                        'should be done when the Jenkinsfile in the given ' +
                        'branch has different parameters than what are ' +
                        'currently displayed (the current job definition). Once ' +
                        'the new job definition is loaded, the new ' +
                        'parameters will be present.'
        )

    }

    environment {

        GIT_REPO =                          "https://github.com/indigobio/qa-grid-smoke.git"
        JENKINS_SECRETS_GITHUB_ID =         '8c80a72e-97bb-445e-8c57-4702656b51be'

    }

    agent {
        node { label 'oq' }
    }

     stages {

         stage('Job Definition Check') {
           steps {
             script {
               if ("${params.RELOAD_JOB_DEFINITION}" == "true") {
                 currentBuild.result = 'ABORTED'
                 error("Job redefined as requested. Now run again to use the new definition.")
               }
             }
           }
         }

         stage('setup') {

              steps {

//                  script {
//                      echo sh(returnStdout: true, script: 'env')
//                  }

                 checkout(
                     changelog: false,
                     poll: false,
                     scm: [
                          $class:                             'GitSCM',
                          branches:                           [[name: params.GIT_BRANCH]],
                          doGenerateSubmoduleConfigurations:  false,
                          extensions: [
                              [$class: 'RelativeTargetDirectory', relativeTargetDir: '.'],
                              [$class: 'CloneOption', depth: 1, noTags: true, reference: '', shallow: true]
                          ],
                          submoduleCfg: [],
                          userRemoteConfigs: [
                              [
                              credentialsId:  env.JENKINS_SECRETS_GITHUB_ID,
                              url:            env.GIT_REPO
                              ]
                          ]
                      ]
                 )

                 sh 'bundle install --quiet'

             }

         }

         stage('tests') {

             steps {
                     script {

                         execCmd = testsCommand()
                         echo( execCmd )
                         sh( execCmd )

                     }
             }
         }

     }

    post {

        always {
            cleanWs notFailBuild: true
        }

        aborted {
            echo 'aborted'
        }

    }

}
