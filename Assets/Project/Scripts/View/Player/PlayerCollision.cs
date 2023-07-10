using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollision : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.CompareTag("Death"))
        {
            Debug.Log("DEATH");
        }
        else if (collision.transform.CompareTag("On"))
        {
            collision.transform.GetComponent<AnimationPresenter>().Play();
        }

    }
    
    private void OnTriggerEnter(Collider collision)
    {
        if (collision.transform.CompareTag("On"))
        {
            collision.transform.GetComponent<AnimationPresenter>().Play();
        }

    }
}
