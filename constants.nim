import dotenv, os

let env = initDotEnv()
env.overload()

let TOKEN*: string = getEnv("TOKEN")